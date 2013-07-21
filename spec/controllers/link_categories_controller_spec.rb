require 'spec_helper'

describe LinkCategoriesController do
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  def valid_attributes
    {:title => "Link Title"}
  end

  describe "GET index" do
    it "assigns all link_categories as @link_categories" do
      link_category = LinkCategory.create! valid_attributes
      get :index
      assigns(:link_categories).should eq([link_category])
    end
  end

  describe "GET show" do
    it "assigns the requested link_category as @link_category" do
      link_category = LinkCategory.create! valid_attributes
      get :show, :id => link_category.id.to_s
      assigns(:link_category).should eq(link_category)
    end
  end

  describe "GET new" do
    it "assigns a new link_category as @link_category" do
      get :new
      assigns(:link_category).should be_a_new(LinkCategory)
    end
  end

  describe "GET edit" do
    it "assigns the requested link_category as @link_category" do
      link_category = LinkCategory.create! valid_attributes
      get :edit, :id => link_category.id.to_s
      assigns(:link_category).should eq(link_category)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new LinkCategory" do
        expect {
          post :create, :link_category => valid_attributes
        }.to change(LinkCategory, :count).by(1)
      end

      it "assigns a newly created link_category as @link_category" do
        post :create, :link_category => valid_attributes
        assigns(:link_category).should be_a(LinkCategory)
        assigns(:link_category).should be_persisted
      end

      it "redirects to the created link_category" do
        post :create, :link_category => valid_attributes
        response.should redirect_to(LinkCategory.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved link_category as @link_category" do
        # Trigger the behavior that occurs when invalid params are submitted
        LinkCategory.any_instance.stub(:save).and_return(false)
        post :create, :link_category => {}
        assigns(:link_category).should be_a_new(LinkCategory)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        LinkCategory.any_instance.stub(:save).and_return(false)
        post :create, :link_category => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested link_category" do
        link_category = LinkCategory.create! valid_attributes
        # Assuming there are no other link_categories in the database, this
        # specifies that the LinkCategory created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        LinkCategory.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => link_category.id, :link_category => {'these' => 'params'}
      end

      it "assigns the requested link_category as @link_category" do
        link_category = LinkCategory.create! valid_attributes
        put :update, :id => link_category.id, :link_category => valid_attributes
        assigns(:link_category).should eq(link_category)
      end

      it "redirects to the link_category" do
        link_category = LinkCategory.create! valid_attributes
        put :update, :id => link_category.id, :link_category => valid_attributes
        response.should redirect_to(link_category)
      end
    end

    describe "with invalid params" do
      it "assigns the link_category as @link_category" do
        link_category = LinkCategory.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LinkCategory.any_instance.stub(:save).and_return(false)
        put :update, :id => link_category.id.to_s, :link_category => {}
        assigns(:link_category).should eq(link_category)
      end

      it "re-renders the 'edit' template" do
        link_category = LinkCategory.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LinkCategory.any_instance.stub(:save).and_return(false)
        put :update, :id => link_category.id.to_s, :link_category => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested link_category" do
      link_category = LinkCategory.create! valid_attributes
      expect {
        delete :destroy, :id => link_category.id.to_s
      }.to change(LinkCategory, :count).by(-1)
    end

    it "redirects to the link_categories list" do
      link_category = LinkCategory.create! valid_attributes
      delete :destroy, :id => link_category.id.to_s
      response.should redirect_to(link_categories_url)
    end
  end

end
