require 'spec_helper'
require 'authentication_spec_helper'

describe LootTypesController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  def valid_attributes
    {:name => "Can O' Whoop Ass"}
  end

  describe "GET index" do
    it "assigns all loot_types as @loot_types" do
      loot_type = LootType.create! valid_attributes
      get :index
      assigns(:loot_types).should eq([loot_type])
    end
  end

  describe "GET show" do
    it "assigns the requested loot_type as @loot_type" do
      loot_type = LootType.create! valid_attributes
      get :show, :id => loot_type.id.to_s
      assigns(:loot_type).should eq(loot_type)
    end
  end

  describe "GET new" do
    it "assigns a new loot_type as @loot_type" do
      get :new
      assigns(:loot_type).should be_a_new(LootType)
    end
  end

  describe "GET edit" do
    it "assigns the requested loot_type as @loot_type" do
      loot_type = LootType.create! valid_attributes
      get :edit, :id => loot_type.id.to_s
      assigns(:loot_type).should eq(loot_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new LootType" do
        expect {
          post :create, :loot_type => valid_attributes
        }.to change(LootType, :count).by(1)
      end

      it "assigns a newly created loot_type as @loot_type" do
        post :create, :loot_type => valid_attributes
        assigns(:loot_type).should be_a(LootType)
        assigns(:loot_type).should be_persisted
      end

      it "redirects to the created loot_type" do
        post :create, :loot_type => valid_attributes
        response.should redirect_to(LootType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved loot_type as @loot_type" do
        # Trigger the behavior that occurs when invalid params are submitted
        LootType.any_instance.stub(:save).and_return(false)
        post :create, :loot_type => {}
        assigns(:loot_type).should be_a_new(LootType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        LootType.any_instance.stub(:save).and_return(false)
        post :create, :loot_type => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested loot_type" do
        loot_type = LootType.create! valid_attributes
        # Assuming there are no other loot_types in the database, this
        # specifies that the LootType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        LootType.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => loot_type.id, :loot_type => {'these' => 'params'}
      end

      it "assigns the requested loot_type as @loot_type" do
        loot_type = LootType.create! valid_attributes
        put :update, :id => loot_type.id, :loot_type => valid_attributes
        assigns(:loot_type).should eq(loot_type)
      end

      it "redirects to the loot_type" do
        loot_type = LootType.create! valid_attributes
        put :update, :id => loot_type.id, :loot_type => valid_attributes
        response.should redirect_to(loot_type)
      end
    end

    describe "with invalid params" do
      it "assigns the loot_type as @loot_type" do
        loot_type = LootType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LootType.any_instance.stub(:save).and_return(false)
        put :update, :id => loot_type.id.to_s, :loot_type => {}
        assigns(:loot_type).should eq(loot_type)
      end

      it "re-renders the 'edit' template" do
        loot_type = LootType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LootType.any_instance.stub(:save).and_return(false)
        put :update, :id => loot_type.id.to_s, :loot_type => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested loot_type" do
      loot_type = LootType.create! valid_attributes
      expect {
        delete :destroy, :id => loot_type.id.to_s
      }.to change(LootType, :count).by(-1)
    end

    it "redirects to the loot_types list" do
      loot_type = LootType.create! valid_attributes
      delete :destroy, :id => loot_type.id.to_s
      response.should redirect_to(loot_types_url)
    end
  end

end
