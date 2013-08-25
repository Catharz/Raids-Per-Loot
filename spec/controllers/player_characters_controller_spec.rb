require 'spec_helper'
require 'authentication_spec_helper'

describe PlayerCharactersController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  describe 'GET edit' do
    it 'assigns the requested player character as @player_character' do
      player = FactoryGirl.create(:player)
      character = FactoryGirl.create(:character, player_id: player.id)

      get :edit, :id => character.id, format: :js

      assigns(:player_character).character.should eq(character)
      assigns(:player_character).player.should eq(player)
    end
  end
end