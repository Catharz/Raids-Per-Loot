require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe LinksController do
  fixtures :users

  before(:each) do
    login_as :quentin
  end

  # This should return the minimal set of attributes required to create a valid
  # Link. As you add validations to Link, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:title => "Link Title"}
  end

  describe "GET index" do
    it "assigns all links as @links" do
      link = Link.create! valid_attributes
      get :index
      assigns(:links).should eq([link])
    end
  end

  describe "GET show" do
    it "assigns the requested link as @link" do
      link = Link.create! valid_attributes
      get :show, :id => link.id.to_s
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
      link = Link.create! valid_attributes
      get :edit, :id => link.id.to_s
      assigns(:link).should eq(link)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Link" do
        expect {
          post :create, :link => valid_attributes
        }.to change(Link, :count).by(1)
      end

      it "assigns a newly created link as @link" do
        post :create, :link => valid_attributes
        assigns(:link).should be_a(Link)
        assigns(:link).should be_persisted
      end

      it "redirects to the created link" do
        post :create, :link => valid_attributes
        response.should redirect_to(Link.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved link as @link" do
        # Trigger the behavior that occurs when invalid params are submitted
        Link.any_instance.stub(:save).and_return(false)
        post :create, :link => {}
        assigns(:link).should be_a_new(Link)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Link.any_instance.stub(:save).and_return(false)
        post :create, :link => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested link" do
        link = Link.create! valid_attributes
        # Assuming there are no other links in the database, this
        # specifies that the Link created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Link.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => link.id, :link => {'these' => 'params'}
      end

      it "assigns the requested link as @link" do
        link = Link.create! valid_attributes
        put :update, :id => link.id, :link => valid_attributes
        assigns(:link).should eq(link)
      end

      it "redirects to the link" do
        link = Link.create! valid_attributes
        put :update, :id => link.id, :link => valid_attributes
        response.should redirect_to(link)
      end
    end

    describe "with invalid params" do
      it "assigns the link as @link" do
        link = Link.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Link.any_instance.stub(:save).and_return(false)
        put :update, :id => link.id.to_s, :link => {}
        assigns(:link).should eq(link)
      end

      it "re-renders the 'edit' template" do
        link = Link.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Link.any_instance.stub(:save).and_return(false)
        put :update, :id => link.id.to_s, :link => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested link" do
      link = Link.create! valid_attributes
      expect {
        delete :destroy, :id => link.id.to_s
      }.to change(Link, :count).by(-1)
    end

    it "redirects to the links list" do
      link = Link.create! valid_attributes
      delete :destroy, :id => link.id.to_s
      response.should redirect_to(links_url)
    end
  end

end
