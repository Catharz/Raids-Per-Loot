require 'spec_helper'

describe 'Pages' do
  describe 'GET /pages' do
    it 'responds with success' do
      get pages_path

      response.status.should be(200)
    end

    it 'assigns the pages to @pages' do
      page = FactoryGirl.create(:page)

      get pages_path

      assigns(:pages).should eq [page]
    end

    it 'displays the pages name' do
      page = FactoryGirl.create(:page)

      visit pages_path

      response.body.should include page.name
    end
  end
end
