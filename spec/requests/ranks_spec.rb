require 'spec_helper'

describe 'Ranks' do
  describe 'GET /ranks' do
    it 'responds with success' do
      get ranks_path

      response.status.should be(200)
    end

    it 'assigns the ranks to @ranks' do
      rank = FactoryGirl.create(:rank)

      get ranks_path

      assigns(:ranks).should eq [rank]
    end

    it 'displays the ranks name' do
      rank = FactoryGirl.create(:rank)

      visit ranks_path

      response.body.should include rank.name
    end
  end
end
