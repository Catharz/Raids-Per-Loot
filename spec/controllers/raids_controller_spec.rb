require 'spec_helper'
require 'authentication_spec_helper'

describe RaidsController do
  include AuthenticationSpecHelper
  fixtures :users, :services, :raid_types

  before(:each) do
    login_as :admin
  end

  def valid_attributes
    FactoryGirl.build(:raid).attributes.symbolize_keys
  end

  describe 'GET index' do
    it 'assigns all raids as @raids' do
      raid = Raid.create! valid_attributes
      get :index
      assigns(:raids).should eq([raid])
    end

    it 'responds with JSON' do
      Raid.create! valid_attributes
      get :index, format: :json
      response.body.should eq Raid.all.to_json
    end

    it 'responds with XML' do
      raid = Raid.create! valid_attributes

      get :index, format: :xml

      response.body.should have_xpath('//raids/*[1]/raid-date')
    end

    it 'filters on raid_date' do
      raid_date = Date.new(2012, 01, 01)
      Raid.create! valid_attributes
      raid = Raid.create! valid_attributes.merge!(raid_date: raid_date)

      get :index, raid_date: raid_date

      assigns(:raids).should eq([raid])
    end

    it 'filters on raid_type' do
      pickup = RaidType.create(name: 'Pickup')
      Raid.create! valid_attributes
      raid = Raid.create! valid_attributes.merge!(raid_type: pickup)

      get :index, raid_type: pickup.name

      assigns(:raids).should eq([raid])
    end
  end

  describe 'GET show' do
    it 'assigns the requested raid as @raid' do
      raid = Raid.create! valid_attributes
      get :show, id: raid.id.to_s
      assigns(:raid).should eq(raid)
    end

    it 'responds with JSON' do
      raid = Raid.create! valid_attributes
      get :show, id: raid, format: :json
      response.body.should eq Raid.last.to_json(methods: [:players, :characters, :instances, :kills, :drops])
    end

    it 'responds with XML' do
      raid = Raid.create! valid_attributes
      get :show, id: raid, format: :xml
      response.body.should have_xpath('//raid/raid-date')
    end
  end

  describe "GET new" do
    it "assigns a new raid as @raid" do
      get :new
      assigns(:raid).should be_a_new(Raid)
    end
  end

  describe "GET edit" do
    it "assigns the requested raid as @raid" do
      raid = Raid.create! valid_attributes
      get :edit, id: raid.id.to_s
      assigns(:raid).should eq(raid)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Raid" do
        expect {
          post :create, raid: valid_attributes
        }.to change(Raid, :count).by(1)
      end

      it "assigns a newly created raid as @raid" do
        post :create, raid: valid_attributes
        assigns(:raid).should be_a(Raid)
        assigns(:raid).should be_persisted
      end

      it "redirects to the created raid" do
        post :create, raid: valid_attributes
        response.should redirect_to(Raid.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved raid as @raid" do
        # Trigger the behavior that occurs when invalid params are submitted
        Raid.any_instance.stub(:save).and_return(false)
        post :create, raid: {"raid_date" => "2014-05-06"}
        assigns(:raid).should be_a_new(Raid)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Raid.any_instance.stub(:save).and_return(false)
        post :create, raid: {"raid_date" => "2014-05-06"}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested raid" do
        raid = Raid.create! valid_attributes
        # Assuming there are no other raids in the database, this
        # specifies that the Raid created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Raid.any_instance.should_receive(:update_attributes).
            with({"raid_date" => "2014-05-06"})
        put :update, id: raid.id, raid: {"raid_date" => "2014-05-06"}
      end

      it "assigns the requested raid as @raid" do
        raid = Raid.create! valid_attributes
        put :update, id: raid.id, raid: valid_attributes
        assigns(:raid).should eq(raid)
      end

      it "redirects to the raid" do
        raid = Raid.create! valid_attributes
        put :update, id: raid.id, raid: valid_attributes
        response.should redirect_to(raid)
      end
    end

    describe "with invalid params" do
      it "assigns the raid as @raid" do
        raid = Raid.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Raid.any_instance.stub(:save).and_return(false)
        put :update, id: raid.id.to_s, raid: {"raid_date" => "2014-05-06"}
        assigns(:raid).should eq(raid)
      end

      it "re-renders the 'edit' template" do
        raid = Raid.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Raid.any_instance.stub(:save).and_return(false)
        put :update, id: raid.id.to_s, raid: {"raid_date" => "2014-05-06"}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested raid" do
      raid = Raid.create! valid_attributes
      expect {
        delete :destroy, id: raid.id.to_s
      }.to change(Raid, :count).by(-1)
    end

    it "redirects to the raids list" do
      raid = Raid.create! valid_attributes
      delete :destroy, id: raid.id.to_s
      response.should redirect_to(raids_url)
    end
  end
end
