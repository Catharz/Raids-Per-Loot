require 'resque/tasks'

task 'resque:setup' => :environment do
  File.open(ENV['PIDFILE'], 'w') { |f| f << Process.pid } if ENV['PIDFILE']
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end