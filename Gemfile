source 'http://rubygems.org'

gem 'rails', '3.1.12'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'

gem 'haml-rails'
gem 'coffee-filter'
gem 'ruby_parser'
gem 'hpricot'
gem 'escape_utils'
gem 'formtastic'
gem 'cocoon'
gem 'nested_form'
gem 'memoist'
gem 'make_resourceful'

gem 'crack'
gem 'httparty'
gem 'nokogiri'
gem 'delayed_job_active_record'

gem 'json'
gem 'RedCloth'
gem 'jquery-rails'

gem 'in_place_editing'
gem 'will_paginate'
gem 'acts_as_tree'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "3.1.4"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'therubyracer'

#group :production do
#  gem 'therubyracer-heroku', '0.8.1.pre3'
#end

# Use unicorn as the web server
# gem 'unicorn'

gem 'bullet', :group => :development

group :test do
  gem "shoulda-matchers"
end

#START:dev_and_test_gems
group :test, :development do
  # Pretty printed test output
  gem "turn", '< 0.8.3', :require => false
  gem "simplecov"

  #START_HIGHLIGHT
  gem "database_cleaner"
  gem "selenium-client"
  #END_HIGHLIGHT

	gem "factory_girl_rails"
  gem "rspec-rails"
  gem "capybara"
  gem "cucumber-rails", :require => false
  gem "webrat"
  gem "spork"
	gem "test-unit", "2.4.7"

  # Guard Configuration
  gem "launchy"
  #gem "rb-fsevent", :require => false if RUBY_PLATFORM =~ /darwin/i
  gem "rb-fsevent"
  gem "guard-bundler"
	gem "guard-test"
	gem "guard-cucumber"
  gem "guard-rspec"
	gem "guard-haml"
  gem "guard-livereload"
  gem "guard-spork"
  gem "growl"

  # Deploy with Heroku
  #gem "heroku"
  #gem "taps"

  #Deploy with Capistrano
  gem 'rvm-capistrano'

	# To use debugger
	#gem 'ruby-debug'
	gem "ruby-prof"
end
