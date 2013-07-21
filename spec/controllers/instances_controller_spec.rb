require 'spec_helper'

describe InstancesController do
  fixtures :users, :services

  before(:each) do
    login_as :admin

    @raid_date = Date.new(2012, 11, 20)
    @progression = FactoryGirl.create(:raid_type, name: 'Progression')
    @raid = FactoryGirl.create(:raid, raid_date: @raid_date, raid_type: @progression)
    @zone = FactoryGirl.create(:zone, name: 'Wherever')
  end

  def valid_attributes
    {raid_id: @raid.id, zone_id: @zone.id, start_time: @raid_date + 20.hours}
  end


  describe 'GET #option_list' do
    it 'should populate an option list with sorted instances' do
      instance1 = FactoryGirl.create(:instance)
      instance2 = FactoryGirl.create(:instance)
      get :option_list
      response.body.should eq("<option value='0'>Select Instance</option>" +
                                  "<option value='#{instance1.id}'>#{instance1.zone_name} - #{instance1.start_time}</option>" +
                                  "<option value='#{instance2.id}'>#{instance2.zone_name} - #{instance2.start_time}</option>")
    end
  end

  context 'GET #index' do
    it 'populates a collection of instances' do
      instance = FactoryGirl.create(:instance)
      get :index
      assigns(:instances).should eq([instance])
    end

    it 'renders the :index view' do
      get :index
      response.should render_template :index
    end

    context 'filters' do
      it 'by zone' do
        Instance.create(valid_attributes)
        zone2 = FactoryGirl.create(:zone, name: 'Somewhere Else')
        instance2 = Instance.create(valid_attributes.merge!(start_time: @raid_date + 21.hours, zone_id: zone2.id))

        get :index, zone_id: zone2.id
        assigns(:instances).should eq [instance2]
      end

      it 'by start time' do
        Instance.create(valid_attributes)
        instance2 = Instance.create(valid_attributes.merge!(start_time: @raid_date + 21.hours))

        get :index, start_time: DateTime.parse("2012-11-20 10:00:00")
        assigns(:instances).should eq [instance2]
      end

      it 'by raid' do
        Instance.create(valid_attributes)
        raid2 = FactoryGirl.create(:raid, raid_date: Date.parse("2012-11-21"), raid_type: @progression)
        instance2 = Instance.create(valid_attributes.merge!(start_time: raid2.raid_date + 21.hours, raid_id: raid2.id))

        get :index, raid_id: raid2.id
        assigns(:instances).should eq [instance2]
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested instance to @instance' do
      instance = FactoryGirl.create(:instance)
      get :show, id: instance
      assigns(:instance).should eq(instance)
    end

    it 'renders the :show template' do
      get :show, id: FactoryGirl.create(:instance)
      response.should render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new instance to @instance' do
      instance = Instance.new
      Instance.should_receive(:new).and_return(instance)
      get :new
      assigns(:instance).should eq(instance)
    end

    it 'renders the :new template' do
      get :new
      response.should render_template :new
    end
  end

  describe "GET edit" do
    it 'assigns the requested item as @instance' do
      instance = Instance.create! valid_attributes
      get :edit, :id => instance.id.to_s
      assigns(:instance).should eq(instance)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new instance' do
        expect {
          post :create, instance: FactoryGirl.build(:instance).attributes.symbolize_keys
        }.to change(Instance, :count).by(1)
      end

      it 'redirects to the new instance' do
        post :create, instance: FactoryGirl.build(:instance).attributes.symbolize_keys
        response.should redirect_to Instance.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new instance' do
        expect {
          post :create, instance: FactoryGirl.attributes_for(:invalid_instance)
        }.to_not change(Instance, :count)
      end

      it 're-renders the :new template' do
        post :create, instance: FactoryGirl.attributes_for(:invalid_instance)
        response.should render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @instance = FactoryGirl.create(:instance)
    end

    context 'valid attributes' do
      it 'located the requested @instance' do
        put :update, id: @instance, instance: FactoryGirl.attributes_for(:instance, start_time: Time.zone.parse('01/01/2012 18:00'))
        assigns(:instance).should eq (@instance)
      end

      it "changes @instance's attributes" do
        put :update, id: @instance, instance: FactoryGirl.build(:instance).attributes.symbolize_keys.merge(start_time: Time.zone.parse('01/01/2012 19:00'))
        @instance.reload
        @instance.start_time.should eq(Time.zone.parse('01/01/2012 19:00'))
      end

      it 'redirects to the updated @instance' do
        put :update, id: @instance, instance: FactoryGirl.build(:instance).attributes.symbolize_keys.merge(start_time: Time.zone.parse('01/01/2012 19:00'))
        response.should redirect_to @instance
      end
    end

    context 'invalid attributes' do
      it 'locates the requested @instance' do
        put :update, id: @instance, instance: FactoryGirl.attributes_for(:invalid_instance)
        assigns(:instance).should eq (@instance)
      end

      it "does not change @instance's attributes" do
        put :update, id: @instance, instance: FactoryGirl.build(:invalid_instance).attributes.symbolize_keys.merge(start_time: Time.zone.parse('01/01/2012 19:00'))
        @instance.reload
        @instance.start_time.should_not eq(Time.zone.parse('01/01/2012 19:00'))
      end

      it 're-renders the :edit template' do
        put :update, id: @instance, instance: FactoryGirl.attributes_for(:invalid_instance)
        response.should render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @instance = FactoryGirl.create(:instance)
    end

    it 'deletes the instance' do
      expect {
        delete :destroy, id: @instance
      }.to change(Instance, :count).by(-1)
    end

    it 'redirects to instances#index' do
      delete :destroy, id: @instance
      response.should redirect_to instances_url
    end
  end
end