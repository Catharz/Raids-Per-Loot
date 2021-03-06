#NOTE: You must set these values when running in development
if RUBY_PLATFORM =~ /darwin/i
  rails_root = ENV['PWD']
  rails_env = 'development'
  num_workers = 2
else
  rails_root = ENV['RAILS_ROOT']
  rails_env = 'production'
  num_workers = 5
end

num_workers.times do |num|
  God.watch do |w|
    w.dir = "#{rails_root}"
    w.name = "resque-#{num}"
    w.group = 'resque'
    w.interval = 30.seconds
    w.pid_file = "#{rails_root}/tmp/pids/#{w.name}.pid"
    w.env = {'QUEUE' => "*", 'RAILS_ENV' => rails_env, 'PIDFILE' => w.pid_file}
    w.start = "rake -f #{rails_root}/Rakefile environment resque:work"
    w.log = "#{rails_root}/log/resque_scheduler.log"
    w.err_log = "#{rails_root}/log/resque_scheduler_error.log"

    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = [3, 5]
      end
    end

    # determine the state on startup
    w.transition(:init, {true => :up, false => :start}) do |on|
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
  end
end
