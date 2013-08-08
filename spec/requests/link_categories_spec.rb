require 'spec_helper'

describe 'LinkCategories' do
  describe 'GET /link_categories' do
    it 'responds with success' do
      get link_categories_path

      response.status.should be(200)
    end

    it 'assigns the link_categories to @link_categories' do
      link_category = FactoryGirl.create(:link_category)

      get link_categories_path

      assigns(:link_categories).should eq [link_category]
    end

    it 'displays the link_categories title' do
      link_category = FactoryGirl.create(:link_category)

      visit link_categories_path

      response.body.should include link_category.title
    end
  end
end
