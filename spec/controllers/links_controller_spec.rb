require 'spec_helper'
require 'authentication_spec_helper'

describe LinksController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  describe 'GET index' do
    it 'assigns all links as @links' do
      link = Link.create! FactoryGirl.attributes_for(:link)
      get :index
      assigns(:links).should eq([link])
    end
  end

  describe 'GET list' do
    it 'assigns all link categories as @link_categories' do
      category = LinkCategory.create!(title: 'Link Category',
                                      description: 'Test')
      link = Link.create! FactoryGirl.attributes_for(:link)
      LinkCategoriesLink.create!(link: link, link_category: category)

      get :list
      assigns(:link_categories).should eq([category])
    end
  end

  describe "GET show" do
    it "assigns the requested link as @link" do
      link = Link.create! FactoryGirl.attributes_for(:link)
      get :show, id: link.id.to_s
      assigns(:link).should eq(link)
    end
  end

  describe "GET new" do
    it "assigns a new link as @link" do
      get :new
      assigns(:link).should be_a_new(Link)
    end
  end

  describe "GET edit" do
    it "assigns the requested link as @link" do
      link = Link.create! FactoryGirl.attributes_for(:link)
      get :edit, id: link.id.to_s
      assigns(:link).should eq(link)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Link" do
        expect {
          post :create, link: FactoryGirl.attributes_for(:link)
        }.to change(Link, :count).by(1)
      end

      it "assigns a newly created link as @link" do
        post :create, link: FactoryGirl.attributes_for(:link)
        assigns(:link).should be_a(Link)
        assigns(:link).should be_persisted
      end

      it "redirects to the created link" do
        post :create, link: FactoryGirl.attributes_for(:link)
        response.should redirect_to(Link.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved link as @link" do
        # Trigger the behavior that occurs when invalid params are submitted
        Link.any_instance.stub(:save).and_return(false)
        post :create, link: {"title" => "blah"}
        assigns(:link).should be_a_new(Link)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Link.any_instance.stub(:save).and_return(false)
        post :create, link: {"title" => "blah"}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested link" do
        link = Link.create! FactoryGirl.attributes_for(:link)
        # Assuming there are no other links in the database, this
        # specifies that the Link created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Link.any_instance.should_receive(:update_attributes).
            with({'url' => '.'})
        put :update, id: link.id, link: {'url' => '.'}
      end

      it "assigns the requested link as @link" do
        link = Link.create! FactoryGirl.attributes_for(:link)
        put :update, id: link.id, link: FactoryGirl.attributes_for(:link)
        assigns(:link).should eq(link)
      end

      it "redirects to the link" do
        link = Link.create! FactoryGirl.attributes_for(:link)
        put :update, id: link.id, link: FactoryGirl.attributes_for(:link)
        response.should redirect_to(link)
      end
    end

    describe "with invalid params" do
      it "assigns the link as @link" do
        link = Link.create! FactoryGirl.attributes_for(:link)
        # Trigger the behavior that occurs when invalid params are submitted
        Link.any_instance.stub(:save).and_return(false)
        put :update, id: link.id.to_s, link: {}
        assigns(:link).should eq(link)
      end

      it "re-renders the 'edit' template" do
        link = Link.create! FactoryGirl.attributes_for(:link)
        # Trigger the behavior that occurs when invalid params are submitted
        Link.any_instance.stub(:save).and_return(false)
        put :update, id: link.id.to_s, link: {"title" => "blah"}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested link" do
      link = Link.create! FactoryGirl.attributes_for(:link)
      expect {
        delete :destroy, id: link.id.to_s
      }.to change(Link, :count).by(-1)
    end

    it "redirects to the links list" do
      link = Link.create! FactoryGirl.attributes_for(:link)
      delete :destroy, id: link.id.to_s
      response.should redirect_to(links_url)
    end
  end
end
