require 'test_helper'
require 'rails/performance_test_help'

class BrowsingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  def test_homepage
    get '/'
  end

  def test_players
    get '/players'
  end

  def test_characters
    get '/characters'
  end

  def test_items
    get '/items'
  end

  def test_drops
    get '/drops'
  end
end
