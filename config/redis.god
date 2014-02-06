# Redis
rails_root = RUBY_PLATFORM =~ /darwin/i ? ENV['PWD'] : ENV['RAILS_ROOT']

%w{6379}.each do |port|
  God.watch do |w|
    w.name = 'redis-server'
    w.interval = 30.seconds
    w.start = "/etc/init.d/redis_#{port} start"
    w.stop = "/etc/init.d/redis_#{port} stop"
    w.restart = "/etc/init.d/redis_#{port} restart"
    w.start_grace = 10.seconds
    w.restart_grace = 10.seconds
    w.pid_file = "#{rails_root}/tmp/pids/#{w.name}.pid"
    w.log      = "#{rails_root}/log/redis_scheduler.log"
    w.err_log  = "#{rails_root}/log/redis_scheduler_error.log"

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end
  end
end
