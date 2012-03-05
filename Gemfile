source 'http://rubygems.org'

gem 'rails', '3.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

gem 'haml'
gem 'ruby_parser'
gem 'hpricot'
gem 'escape_utils'

gem 'json'
gem 'RedCloth'
gem 'jquery-rails'

gem 'in_place_editing'
gem 'will_paginate'
gem 'acts_as_tree'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

#START:dev_and_test_gems
group :test do
# Pretty printed test output
  gem 'turn', '< 0.8.3', :require => false

  #START_HIGHLIGHT
  gem "database_cleaner"
  gem "selenium-client"
  #END_HIGHLIGHT

	gem "factory_girl_rails"
  gem "rspec-rails"
  gem "cucumber-rails", :require => false
  gem "webrat"
	gem "test-unit"
end

# Deploy with Heroku
group :development, :test do
	gem 'heroku'
  gem 'taps'

	# To use debugger
	#gem 'ruby-debug'
	#gem 'ruby-prof'
end
