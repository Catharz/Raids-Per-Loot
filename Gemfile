source 'http://rubygems.org'

gem 'rails', '3.1.12'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'squeel'

gem 'haml-rails'
gem 'ruby_parser'
gem 'hpricot'
gem 'escape_utils'
gem 'formtastic'
gem 'cocoon'
gem 'nested_form'
gem 'memoist'
gem 'make_resourceful'
gem 'jbuilder'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google'
gem 'omniauth-steam'
gem 'omniauth-openid'
gem 'omniauth-yahoo'
gem 'cancan'
gem 'paper_trail'

gem 'crack'
gem 'httparty'
gem 'nokogiri'
gem 'resque', :require => 'resque/server'
gem 'god'

gem 'json'
gem 'RedCloth'
gem 'jquery-rails'

gem 'will_paginate'
gem 'acts_as_tree'
gem 'virtus'

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
gem 'thin'
gem 'passenger', :group => :production

group :development do
  gem 'bullet'
  gem 'pry-rails'
end


#START:dev_and_test_gems
group :test, :development do
  # Pretty printed test output
  gem "turn", '< 0.8.3', :require => false
  gem "simplecov"

  #START_HIGHLIGHT
  gem "database_cleaner"
  gem "selenium-client"
  gem "selenium-webdriver"
  #END_HIGHLIGHT

	gem "factory_girl_rails"
  gem "rspec-rails"
  gem "capybara"
  gem "cucumber-rails", :require => false
  gem "webrat"
  gem "spork"
	gem "test-unit", "2.4.7"
  gem 'timecop'
  gem "shoulda-matchers"

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
  gem 'capistrano'

	# To use debugger
	#gem 'ruby-debug'
	gem "ruby-prof"
end
