require 'spec_helper'
require 'authentication_spec_helper'

describe ZonesController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  def valid_attributes
    {name: 'Wherever'}
  end

  describe 'GET #option_list' do
    it 'populates an option list with sorted zone names' do
      zone1 = FactoryGirl.create(:zone)
      zone2 = FactoryGirl.create(:zone)

      get :option_list

      expect(response.body).to \
        eq("<option value='0'>Select Zone</option>" +
           "<option value='#{zone1.id}'>#{zone1.name}</option>" +
           "<option value='#{zone2.id}'>#{zone2.name}</option>")
    end

    it 'filters the list by instance_id' do
      FactoryGirl.create(:zone)
      zone = FactoryGirl.create(:zone)
      instance = FactoryGirl.create(:instance, zone_id: zone.id)

      get :option_list, instance_id: instance.id

      expect(response.body).to \
        eq("<option value='0'>Select Zone</option>" +
           "<option value='#{zone.id}'>#{zone.name}</option>")
    end
  end

  describe 'GET index' do
    it 'assigns zones as @zones' do
      zone = FactoryGirl.create(:zone, valid_attributes)

      get :index

      expect(assigns(:zones)).to include zone
    end

    it 'filters by name' do
      FactoryGirl.create(:zone, valid_attributes)
      zone2 = FactoryGirl.create(:zone, {name: 'The Farm'})

      get :index, name: 'The Farm'

      expect(assigns(:zones)).to include zone2
    end

    it 'renders xml' do
      zone = FactoryGirl.create(:zone)

      get :index, format: :xml

      expect(response.content_type).to eq 'application/xml'
      expect(response.body).to have_selector('zones', type: 'array') do |results|
        expect(results).to have_selector('zone') do |pr|
          expect(pr).to have_selector('id', type: 'integer', content: zone.id.to_s)
          expect(pr).to have_selector('name', content: zone.name)
          expect(pr).to have_selector('difficulty-id',
                                      type: 'integer',
                                      content: zone.difficulty_id.to_s)
        end
      end
    end

    it 'renders json' do
      zone = FactoryGirl.create(:zone)

      get :index, format: :json

      expect(response.content_type).to eq 'application/json'
      expect(JSON.parse(response.body)).to include JSON.parse(zone.to_json)
    end
  end

  describe 'GET show' do
    it 'assigns the requested zone as @zone' do
      zone = FactoryGirl.create(:zone, valid_attributes)

      get :show, id: zone.id.to_s

      expect(assigns(:zone)).to eq zone
    end

    it 'renders xml' do
      zone = FactoryGirl.create(:zone)

      get :show, format: :xml, id: zone.id

      expect(response.content_type).to eq 'application/xml'
      expect(response.body).to eq zone.to_xml
    end

    it 'renders json' do
      zone = FactoryGirl.create(:zone)

      get :show, format: :json, id: zone

      expect(response.content_type).to eq 'application/json'
      expect(JSON.parse(response.body)).to eq JSON.parse(zone.to_json)
    end
  end

  describe 'GET new' do
    it 'assigns a new zone as @zone' do
      get :new
      expect(assigns(:zone)).to be_a_new Zone
    end
  end

  describe 'GET edit' do
    it 'assigns the requested zone as @zone' do
      zone = FactoryGirl.create(:zone, valid_attributes)
      get :edit, id: zone.id.to_s
      expect(assigns(:zone)).to eq zone
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Zone' do
        expect {
          post :create, zone: valid_attributes
        }.to change(Zone, :count).by 1
      end

      it 'assigns a newly created zone as @zone' do
        post :create, zone: valid_attributes
        expect(assigns(:zone)).to be_a Zone
        expect(assigns(:zone)).to be_persisted
      end

      it 'redirects to the created zone' do
        post :create, zone: valid_attributes
        expect(response).to redirect_to Zone.last
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved zone as @zone' do
        # Trigger the behavior that occurs when invalid params are submitted
        Zone.any_instance.stub(:save).and_return(false)
        post :create, zone: valid_attributes
        expect(assigns(:zone)).to be_a_new Zone
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Zone.any_instance.stub(:save).and_return(false)
        post :create, zone: valid_attributes
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested zone' do
        zone = FactoryGirl.create(:zone, valid_attributes)
        put :update, id: zone.id, zone: {"name" => "Anywhere"}
        zone.reload
        expect(zone.name).to eq 'Anywhere'
      end

      it 'assigns the requested zone as @zone' do
        zone = FactoryGirl.create(:zone, valid_attributes)
        put :update, id: zone.id, zone: valid_attributes
        expect(assigns(:zone)).to eq zone
      end

      it 'redirects to the zone' do
        zone = FactoryGirl.create(:zone, valid_attributes)
        put :update, id: zone.id, zone: valid_attributes
        expect(response).to redirect_to zone
      end
    end

    describe 'with invalid params' do
      it 'assigns the zone as @zone' do
        zone = FactoryGirl.create(:zone, valid_attributes)
        Zone.any_instance.stub(:save).and_return(false)
        put :update, id: zone.id.to_s, zone: {"name" => "wherever"}
        expect(assigns(:zone)).to eq zone
      end

      it "re-renders the 'edit' template" do
        zone = FactoryGirl.create(:zone, valid_attributes)
        # Trigger the behavior that occurs when invalid params are submitted
        Zone.any_instance.stub(:save).and_return(false)
        put :update, id: zone.id.to_s, zone: {"name" => "wherever"}
        expect(response).to render_template 'edit'
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested zone' do
      zone = FactoryGirl.create(:zone, valid_attributes)
      expect {
        delete :destroy, id: zone.id.to_s
      }.to change(Zone, :count).by(-1)
    end

    it 'redirects to the zones list' do
      zone = FactoryGirl.create(:zone, valid_attributes)
      delete :destroy, id: zone.id.to_s
      expect(response).to redirect_to zones_url
    end
  end
end
