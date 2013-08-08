require 'spec_helper'

describe 'Links' do
  describe 'GET /links' do
    it 'responds with success' do
      get links_path

      response.status.should be(200)
    end

    it 'assigns the links to @links' do
      link = FactoryGirl.create(:link)

      get links_path

      assigns(:links).should eq [link]
    end

    it 'displays the links title' do
      link = FactoryGirl.create(:link)

      visit links_path

      response.body.should include link.title
    end
  end
end
