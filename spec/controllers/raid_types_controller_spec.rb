require 'spec_helper'

describe RaidTypesController do
  fixtures :users

  before(:each) do
    login_as :quentin
  end

  def valid_attributes
    {:name => 'Whatever'}
  end
  
  describe "GET index" do
    it 'assigns all raid_types as @raid_types' do
      raid_type = RaidType.create! valid_attributes
      get :index, {}
      assigns(:raid_types).should eq([raid_type])
    end

    it 'filters by name' do
      RaidType.create! valid_attributes
      pickup = RaidType.create! valid_attributes.merge!(name: 'Pickup')
      get :index, name: 'Pickup'
      assigns(:raid_types).should eq([pickup])
    end
  end

  describe "GET show" do
    it "assigns the requested raid_type as @raid_type" do
      raid_type = RaidType.create! valid_attributes
      get :show, {:id => raid_type.to_param}
      assigns(:raid_type).should eq(raid_type)
    end
  end

  describe "GET new" do
    it "assigns a new raid_type as @raid_type" do
      get :new, {}
      assigns(:raid_type).should be_a_new(RaidType)
    end
  end

  describe "GET edit" do
    it "assigns the requested raid_type as @raid_type" do
      raid_type = RaidType.create! valid_attributes
      get :edit, {:id => raid_type.to_param}
      assigns(:raid_type).should eq(raid_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new RaidType" do
        expect {
          post :create, {:raid_type => valid_attributes}
        }.to change(RaidType, :count).by(1)
      end

      it "assigns a newly created raid_type as @raid_type" do
        post :create, {:raid_type => valid_attributes}
        assigns(:raid_type).should be_a(RaidType)
        assigns(:raid_type).should be_persisted
      end

      it "redirects to the created raid_type" do
        post :create, {:raid_type => valid_attributes}
        response.should redirect_to(RaidType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved raid_type as @raid_type" do
        # Trigger the behavior that occurs when invalid params are submitted
        RaidType.any_instance.stub(:save).and_return(false)
        post :create, {:raid_type => {}}
        assigns(:raid_type).should be_a_new(RaidType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        RaidType.any_instance.stub(:save).and_return(false)
        post :create, {:raid_type => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested raid_type" do
        raid_type = RaidType.create! valid_attributes
        # Assuming there are no other raid_types in the database, this
        # specifies that the RaidType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        RaidType.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => raid_type.to_param, :raid_type => {'these' => 'params'}}
      end

      it "assigns the requested raid_type as @raid_type" do
        raid_type = RaidType.create! valid_attributes
        put :update, {:id => raid_type.to_param, :raid_type => valid_attributes}
        assigns(:raid_type).should eq(raid_type)
      end

      it "redirects to the raid_type" do
        raid_type = RaidType.create! valid_attributes
        put :update, {:id => raid_type.to_param, :raid_type => valid_attributes}
        response.should redirect_to(raid_type)
      end
    end

    describe "with invalid params" do
      it "assigns the raid_type as @raid_type" do
        raid_type = RaidType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        RaidType.any_instance.stub(:save).and_return(false)
        put :update, {:id => raid_type.to_param, :raid_type => {}}
        assigns(:raid_type).should eq(raid_type)
      end

      it "re-renders the 'edit' template" do
        raid_type = RaidType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        RaidType.any_instance.stub(:save).and_return(false)
        put :update, {:id => raid_type.to_param, :raid_type => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested raid_type" do
      raid_type = RaidType.create! valid_attributes
      expect {
        delete :destroy, {:id => raid_type.to_param}
      }.to change(RaidType, :count).by(-1)
    end

    it "redirects to the raid_types list" do
      raid_type = RaidType.create! valid_attributes
      delete :destroy, {:id => raid_type.to_param}
      response.should redirect_to(raid_types_url)
    end
  end

end
