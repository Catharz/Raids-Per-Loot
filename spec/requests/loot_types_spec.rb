require 'spec_helper'

describe 'LootTypes' do
  describe 'GET /loot_types' do
    it 'responds with success' do
      get loot_types_path

      response.status.should be(200)
    end

    it 'assigns the loot_types to @loot_types' do
      loot_type = FactoryGirl.create(:loot_type)

      get loot_types_path

      assigns(:loot_types).should include loot_type
    end

    it 'displays the loot_types name' do
      loot_type = FactoryGirl.create(:loot_type)

      visit loot_types_path

      response.body.should include loot_type.name
    end
  end
end
