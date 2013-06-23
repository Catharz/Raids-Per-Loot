if %w{yes true on}.include? ENV['COVERAGE']
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails' do
      add_filter 'test'
      add_filter 'vendor'
      add_group 'Observers', 'app/observers'
      add_group 'DataTables', 'app/datatables'
      add_group 'Workers', 'app/workers'
      add_group 'Changed' do |source_file|
        `git status --untracked=all --porcelain`.split("\n").detect do |status_and_filename|
          _, filename = status_and_filename.split(' ', 2)
          source_file.filename.ends_with?(filename)
        end
      end
    end
    puts 'Running Unit Tests with Coverage'
  end
end

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path('../../lib/authenticated_test_helper', __FILE__)

class ActiveSupport::TestCase
  include AuthenticatedTestHelper
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :users

  # Add more helper methods to be used by all tests here...
end
