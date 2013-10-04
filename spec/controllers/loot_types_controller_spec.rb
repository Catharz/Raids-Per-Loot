require 'spec_helper'
require 'authentication_spec_helper'

describe LootTypesController do
  include AuthenticationSpecHelper
  fixtures :users, :services, :loot_types

  before(:each) do
    login_as :admin
  end

  describe "GET index" do
    it "assigns all loot_types as @loot_types" do
      loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
      get :index
      assigns(:loot_types).should include loot_type
    end

    it 'renders json' do
      loot_types = LootType.all
      get :index, format: :json
      result = JSON.parse(response.body)
      result.should eq loot_types.collect { |lt| JSON.parse(lt.to_json) }
    end

    it 'renders xml' do
      loot_types = LootType.all
      get :index, format: :xml
      response.body.should eq loot_types.to_xml(include: [:items, :drops])
    end
  end

  describe "GET show" do
    it "assigns the requested loot_type as @loot_type" do
      loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
      get :show, id: loot_type.id.to_s
      assigns(:loot_type).should eq(loot_type)
    end

    it 'renders json' do
      loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
      get :show, id: loot_type, format: :json
      result = JSON.parse(response.body)
      result.should eq JSON.parse(loot_type.to_json)
    end

    it 'renders xml' do
      loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
      get :show, id: loot_type, format: :xml
      response.body.should eq loot_type.to_xml
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
      loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
      get :edit, id: loot_type.id.to_s
      assigns(:loot_type).should eq(loot_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new LootType" do
        expect {
          post :create, loot_type: FactoryGirl.attributes_for(:loot_type)
        }.to change(LootType, :count).by(1)
      end

      it "assigns a newly created loot_type as @loot_type" do
        post :create, loot_type: FactoryGirl.attributes_for(:loot_type)
        assigns(:loot_type).should be_a(LootType)
        assigns(:loot_type).should be_persisted
      end

      it "redirects to the created loot_type" do
        post :create, loot_type: FactoryGirl.attributes_for(:loot_type)
        response.should redirect_to(LootType.last)
      end

      it 'responds with JSON' do
        post :create, loot_type: FactoryGirl.attributes_for(:loot_type), format: :json
        response.body.should eq LootType.last.to_json(methods: [:default_loot_method_name])
      end

      it 'responds with XML' do
        post :create, loot_type: FactoryGirl.attributes_for(:loot_type), format: :xml
        response.body.should eq LootType.last.to_xml
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved loot_type as @loot_type" do
        # Trigger the behavior that occurs when invalid params are submitted
        LootType.any_instance.stub(:save).and_return(false)
        post :create, loot_type: {}
        assigns(:loot_type).should be_a_new(LootType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        LootType.any_instance.stub(:save).and_return(false)
        post :create, loot_type: {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested loot_type" do
        loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
        # Assuming there are no other loot_types in the database, this
        # specifies that the LootType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        LootType.any_instance.should_receive(:update_attributes).
            with({'these' => 'params'})
        put :update, id: loot_type.id, loot_type: {'these' => 'params'}
      end

      it "assigns the requested loot_type as @loot_type" do
        loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
        put :update, id: loot_type.id,
            loot_type: FactoryGirl.attributes_for(:loot_type)
        assigns(:loot_type).should eq(loot_type)
      end

      it "redirects to the loot_type" do
        loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
        put :update, id: loot_type.id,
            loot_type: FactoryGirl.attributes_for(:loot_type)
        response.should redirect_to(loot_type)
      end

      it 'responds with JSON' do
        loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
        put :update, id: loot_type.id, loot_type: loot_type.attributes.merge!(name: 'New Name 1'), format: :json
        loot_type.reload
        response.body.should eq loot_type.to_json(methods: [:default_loot_method_name])
      end

      it 'responds with XML' do
        loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
        put :update, id: loot_type.id, loot_type: loot_type.attributes.merge!(name: 'New Name 2'), format: :xml
        loot_type.reload
        response.body.should eq loot_type.to_xml
      end
    end

    describe "with invalid params" do
      it "assigns the loot_type as @loot_type" do
        loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
        # Trigger the behavior that occurs when invalid params are submitted
        LootType.any_instance.stub(:save).and_return(false)
        put :update, id: loot_type.id.to_s, loot_type: {}
        assigns(:loot_type).should eq(loot_type)
      end

      it "re-renders the 'edit' template" do
        loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
        # Trigger the behavior that occurs when invalid params are submitted
        LootType.any_instance.stub(:save).and_return(false)
        put :update, id: loot_type.id.to_s, loot_type: {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested loot_type" do
      loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
      expect {
        delete :destroy, id: loot_type.id.to_s
      }.to change(LootType, :count).by(-1)
    end

    it "redirects to the loot_types list" do
      loot_type = LootType.create! FactoryGirl.attributes_for(:loot_type)
      delete :destroy, id: loot_type.id.to_s
      response.should redirect_to(loot_types_url)
    end
  end
end