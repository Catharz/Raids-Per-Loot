require 'spec_helper'

describe ViewerController do

  describe 'GET show' do
    it 'should be successful' do
      get :show, :name => 'home'
      response.should be_success
    end

    it 'renders the :show template' do
      get :show, :name => 'home'
      response.should render_template :show
    end

    it 'assigns the requested page to @page' do
      p1 = FactoryGirl.create(:page, position: 1)

      get :show, name: p1.name

      assigns(:page).should eq(p1)
    end

    it 'assigns the page title to @pagetitle' do
      p1 = FactoryGirl.create(:page, position: 1)

      get :show, name: p1.name

      assigns(:pagetitle).should eq(p1.title)
    end

    it 'assigns child pages to @subpages' do
      parent = FactoryGirl.create(:page)
      p1 = FactoryGirl.create(:page, position: 1, parent_id: parent.id)
      p2 = FactoryGirl.create(:page, position: 2, parent_id: parent.id)
      p3 = FactoryGirl.create(:page, position: 3, parent_id: parent.id)

      get :show, name: parent.name

      assigns(:subpages).should eq([p1, p2, p3])
    end

    it 'calls login_required if an admin page' do
      p1 = FactoryGirl.create(:page, admin: true)

      controller.should_receive(:login_required).twice

      get :show, name: p1.name
    end
  end

  describe 'POST set_page_body' do
    context 'with valid attributes' do
      it 'assigns the page to @page' do
        p1 = FactoryGirl.create(:page)

        put :set_page_body, id: p1.id

        assigns(:page).should eq(p1)
      end

      it 'updates the page body' do
        p1 = FactoryGirl.create(:page)

        put :set_page_body, id: p1.id, value: 'Hello World!'

        p1.reload
        p1.body.should eq '<p>Hello World!</p>'
      end

      it 'redirects to the view page url' do
        p1 = FactoryGirl.create(:page)

        put :set_page_body, id: p1.id

        response.should redirect_to(view_page_url(p1.name))
      end
    end

    context 'with invalid attributes' do
      it 'renders the page body' do
        p1 = FactoryGirl.create(:page)

        Page.any_instance.should_receive(:update_attribute).and_return(false)
        put :set_page_body, id: p1.id, value: nil

        response.should have_rendered(text: p1.body)
      end
    end
  end

  describe 'GET get_unformatted_text' do
    it 'assigns the page to @page' do
      p1 = FactoryGirl.create(:page)

      get :get_unformatted_text, id: p1.id

      assigns(:page).should eq(p1)
    end

    it 'renders without a layout' do
      p1 = FactoryGirl.create(:page)

      get :get_unformatted_text, id: p1.id

      response.should have_rendered(layout: false, inline: p1.body(:source))
    end
  end
end
