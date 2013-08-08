require 'spec_helper'

describe 'Adjustments' do
  describe 'GET /adjustments' do
    it 'responds with success' do
      get adjustments_path

      response.status.should be(200)
    end

    it 'assigns the adjustments to @adjustments' do
      player = FactoryGirl.create(:player)
      adjustment = FactoryGirl.create(:adjustment, adjustable: player)

      get adjustments_path

      assigns(:adjustments).should eq [adjustment]
    end

    it 'displays the adjusted items name' do
      character = FactoryGirl.create(:character)
      FactoryGirl.create(:adjustment, adjustable: character)

      visit adjustments_path

      response.body.should include character.name
    end
  end
end
