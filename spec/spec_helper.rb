require 'rubygems'
require 'spork'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  if %w{yes true on}.include? ENV['COVERAGE']
    require 'simplecov'
    SimpleCov.start 'rails' do
      add_filter 'spec'
      add_filter 'vendor'
      add_group 'Observers', 'app/observers'
      add_group 'DataTables', 'app/datatables'
      add_group 'Validators', 'app/validators'
      add_group 'Workers', 'app/workers'
      add_group 'Changed' do |source_file|
        `git status --untracked=all --porcelain`.split("\n").detect do |status_and_filename|
          _, filename = status_and_filename.split(' ', 2)
          source_file.filename.ends_with?(filename)
        end
      end
    end
    puts 'Running RSpec with Coverage'
  end

  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'

  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'shoulda/matchers'
  require "capybara/rspec"
  require 'omniauth'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  #def logged_in?
  #  !!@request.session[:user_id] || !!current_user
  #end

  RSpec.configure do |config|
    config.fail_fast = %w{yes true on}.include? ENV['FAIL_FAST']

    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.include FactoryGirl::Syntax::Methods
  end

  Capybara.default_host = 'http://example.org'

  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:developer, {
      :provider => 'developer',
      :uid => '12345',
      'info' => {:name => 'zapnap', :email => 'zapnap@example.org'}
  })

end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
end

def with_versioning
  was_enabled = PaperTrail.enabled?
  PaperTrail.enabled = true
  begin
    yield
  ensure
    PaperTrail.enabled = was_enabled
  end
end