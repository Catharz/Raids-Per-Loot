require 'spec_helper'

describe 'Zones' do
  describe 'GET /zones' do
    it 'responds with success' do
      get zones_path

      response.status.should be(200)
    end

    it 'assigns the zones to @zones' do
      zone = FactoryGirl.create(:zone)

      get zones_path

      assigns(:zones).should eq [zone]
    end

    it 'displays the zones name' do
      zone = FactoryGirl.create(:zone)

      visit zones_path

      response.body.should include zone.name
    end
  end
end
