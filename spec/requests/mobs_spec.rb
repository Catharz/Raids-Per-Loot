require 'spec_helper'

describe 'Mobs' do
  describe 'GET /mobs' do
    it 'responds with success' do
      get mobs_path

      response.status.should be(200)
    end

    it 'assigns the mobs to @mobs' do
      mob = FactoryGirl.create(:mob)

      get mobs_path

      assigns(:mobs).should eq [mob]
    end

    it 'displays the mobs name' do
      mob = FactoryGirl.create(:mob)

      visit mobs_path

      response.body.should include mob.name
    end
  end
end
