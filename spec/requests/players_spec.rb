require 'spec_helper'

describe 'Players' do
  describe 'GET /players' do
    it 'responds with success' do
      get players_path

      response.status.should be(200)
    end

    it 'assigns the players to @players' do
      player = FactoryGirl.create(:player)

      get players_path

      assigns(:players).should eq [player]
    end

    it 'displays the players name' do
      player = FactoryGirl.create(:player)

      visit players_path

      response.body.should include player.name
    end
  end
end
