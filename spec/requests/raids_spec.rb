require 'spec_helper'

describe 'Raids' do
  describe 'GET /raids' do
    it 'responds with success' do
      get raids_path

      response.status.should be(200)
    end

    it 'assigns the raids to @raids' do
      raid = FactoryGirl.create(:raid)

      get raids_path

      assigns(:raids).should eq [raid]
    end

    it 'displays the raid date' do
      raid = FactoryGirl.create(:raid)

      visit raids_path

      response.body.should include raid.raid_date.to_s
    end
  end
end
