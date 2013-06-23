rails_env   = ENV['RAILS_ENV']  || 'production'
rails_root  = ENV['RAILS_ROOT'] || '/home/deploy/app/current'
num_workers = rails_env == 'production' ? 5 : 2

num_workers.times do |num|
  God.watch do |w|
    w.dir      = "#{rails_root}"
    w.name     = "resque-#{num}"
    w.group    = 'resque'
    w.interval = 30.seconds
    w.env      = {'QUEUE'=>"critical,high,low", 'RAILS_ENV'=>rails_env}
    w.start    = "/usr/bin/rake -f #{rails_root}/Rakefile environment resque:work"

    w.log_file  = "#{rails_root}/log/god_resque_#{num}.log"
    w.log_level = :info

    if rails_env == 'production'
      w.uid = 'deploy'
      w.gid = 'deploy'
    end

    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = [3, 5]
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end

    #w.lifecycle do |on|
    #  on.condition(:flapping) do |c|
    #    c.to_state = [:start, :restart]
    #    c.times = 5
    #    c.within = 5.minutes
    #    c.transition = :unmonitored
    #    c.retry_in = 10.minutes
    #    c.retry_times = 5
    #    #c.retry_within 2.hours
    #  end
    #end
  end
end