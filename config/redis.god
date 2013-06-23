# Redis
rails_root  = ENV['RAILS_ROOT'] || '/home/deploy/app/current'

%w{6379}.each do |port|
  God.log_file  = "#{rails_root}/log/god.log"
  God.log_level = :info
  God.watch do |w|
    w.name = 'redis-server'
    w.interval = 30.seconds
    w.start = "/etc/init.d/redis_#{port} start"
    w.stop = "/etc/init.d/redis_#{port} stop"
    w.restart = "/etc/init.d/redis_#{port} restart"
    w.start_grace = 10.seconds
    w.restart_grace = 10.seconds

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end
  end
end