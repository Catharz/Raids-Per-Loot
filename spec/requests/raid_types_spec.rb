require 'spec_helper'

describe 'RaidTypes' do
  describe 'GET /raid_types' do
    it 'responds with success' do
      get raid_types_path

      response.status.should be(200)
    end

    it 'assigns the raid_types to @raid_types' do
      raid_type = FactoryGirl.create(:raid_type)

      get raid_types_path

      assigns(:raid_types).should eq [raid_type]
    end

    it 'displays the raid_types name' do
      raid_type = FactoryGirl.create(:raid_type)

      visit raid_types_path

      response.body.should include raid_type.name
    end
  end
end
