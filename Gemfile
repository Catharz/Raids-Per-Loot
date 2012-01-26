source 'http://rubygems.org'

gem 'rails', '3.0.3'
gem 'rake'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'

gem 'json'
gem 'RedCloth'
gem 'jquery-rails'
gem 'in_place_editing'
gem 'haml'
gem 'will_paginate'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'uglifier'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# Deply with Heroku
group :development, :test do
	gem 'heroku'
  gem 'taps'

	# To use debugger
	#gem 'ruby-debug'
	gem 'ruby-prof'
end

#START:dev_and_test_gems
group :test do
  gem "cucumber-rails"
	gem "test-unit"
  gem "rspec-rails"
  gem "webrat"
  #START_HIGHLIGHT
  gem "database_cleaner"
  gem "selenium-client"
  #END_HIGHLIGHT
end
