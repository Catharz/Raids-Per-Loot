require 'spec_helper'

describe ZonesController do
  fixtures :users

  before(:each) do
    login_as :quentin
  end

  def valid_attributes
    {:name => "Wherever"}
  end

  describe "GET index" do
    it "assigns all zones as @zones" do
      zone = FactoryGirl.create(:zone, valid_attributes)

      get :index
      assigns(:zones).should eq([zone])
    end

    it "filters by name" do
      FactoryGirl.create(:zone, valid_attributes)
      zone2 = FactoryGirl.create(:zone, {:name => 'The Farm'})

      get :index, :name => 'The Farm'
      assigns(:zones).should eq([zone2])
    end
  end

  describe "GET show" do
    it "assigns the requested zone as @zone" do
      zone = FactoryGirl.create(:zone, valid_attributes)
      get :show, :id => zone.id.to_s
      assigns(:zone).should eq(zone)
    end
  end

  describe "GET new" do
    it "assigns a new zone as @zone" do
      get :new
      assigns(:zone).should be_a_new(Zone)
    end
  end

  describe "GET edit" do
    it "assigns the requested zone as @zone" do
      zone = FactoryGirl.create(:zone, valid_attributes)
      get :edit, :id => zone.id.to_s
      assigns(:zone).should eq(zone)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Zone" do
        expect {
          post :create, :zone => valid_attributes
        }.to change(Zone, :count).by(1)
      end

      it "assigns a newly created zone as @zone" do
        post :create, :zone => valid_attributes
        assigns(:zone).should be_a(Zone)
        assigns(:zone).should be_persisted
      end

      it "redirects to the created zone" do
        post :create, :zone => valid_attributes
        response.should redirect_to(Zone.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved zone as @zone" do
        # Trigger the behavior that occurs when invalid params are submitted
        Zone.any_instance.stub(:save).and_return(false)
        post :create, :zone => {}
        assigns(:zone).should be_a_new(Zone)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Zone.any_instance.stub(:save).and_return(false)
        post :create, :zone => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested zone" do
        zone = FactoryGirl.create(:zone, valid_attributes)
        # Assuming there are no other zones in the database, this
        # specifies that the Zone created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Zone.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => zone.id, :zone => {'these' => 'params'}
      end

      it "assigns the requested zone as @zone" do
        zone = FactoryGirl.create(:zone, valid_attributes)
        put :update, :id => zone.id, :zone => valid_attributes
        assigns(:zone).should eq(zone)
      end

      it "redirects to the zone" do
        zone = FactoryGirl.create(:zone, valid_attributes)
        put :update, :id => zone.id, :zone => valid_attributes
        response.should redirect_to(zone)
      end
    end

    describe "with invalid params" do
      it "assigns the zone as @zone" do
        zone = FactoryGirl.create(:zone, valid_attributes)
        # Trigger the behavior that occurs when invalid params are submitted
        Zone.any_instance.stub(:save).and_return(false)
        put :update, :id => zone.id.to_s, :zone => {}
        assigns(:zone).should eq(zone)
      end

      it "re-renders the 'edit' template" do
        zone = FactoryGirl.create(:zone, valid_attributes)
        # Trigger the behavior that occurs when invalid params are submitted
        Zone.any_instance.stub(:save).and_return(false)
        put :update, :id => zone.id.to_s, :zone => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested zone" do
      zone = FactoryGirl.create(:zone, valid_attributes)
      expect {
        delete :destroy, :id => zone.id.to_s
      }.to change(Zone, :count).by(-1)
    end

    it "redirects to the zones list" do
      zone = FactoryGirl.create(:zone, valid_attributes)
      delete :destroy, :id => zone.id.to_s
      response.should redirect_to(zones_url)
    end
  end
end