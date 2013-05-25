namespace :db do
  namespace :fixtures do
    desc 'Create YAML test fixtures from data in an existing database.
    Defaults to development database. Set RAILS_ENV to override.'
    task :dump => :environment do
      if ENV['TABLE']
        extract_fixture(ENV['TABLE'])
      else
        skip_tables = ['schema_migrations']
        ActiveRecord::Base.establish_connection(:development)
        (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
          extract_fixture(table_name)
        end
      end
    end
  end
end

def extract_fixture(table_name)
  i = '000'
  sql = 'SELECT * FROM %s'
  File.open(Rails.root.to_s + "/spec/fixtures/#{table_name}.yml", 'w') do |file|
    data = ActiveRecord::Base.connection.select_all(sql % table_name)
    file.write data.inject({}) { |hash, record|
      hash["#{table_name}_#{i.succ!}"] = record
      hash
    }.to_yaml
  end
end