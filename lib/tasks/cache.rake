namespace :cache do
  desc 'Clear Rails Cache'
  task :clear => :environment do
    Rails.cache.clear
  end
end
