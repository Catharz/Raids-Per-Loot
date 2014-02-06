require 'spec_helper'

describe 'Zones' do
  describe 'GET /zones' do
    it 'responds with success' do
      get zones_path

      expect(response.status).to be 200
    end

    it 'assigns the zones to @zones' do
      zone = FactoryGirl.create(:zone)

      get zones_path

      expect(assigns(:zones)).to include zone
    end

    it 'displays the zones name' do
      zone = FactoryGirl.create(:zone)

      visit zones_path

      expect(response.body).to include zone.name
    end
  end
end