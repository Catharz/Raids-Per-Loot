require 'spec_helper'

describe DropsController do
  fixtures :users

  #These items must exist or the Drop will not be valid
  before(:each) do
    @drop_time = DateTime.new!
    Item.create(:name => "Whatever")
    Player.create(:name => "Me")

    zone = Zone.create!(:name => "Wherever")
    zone.mobs.create(:name => "Whoever")
    raid = Raid.create!(:raid_date => @drop_time.to_date)
    raid.instances.create!(:start_time => @drop_time - 1.hour, :end_time => @drop_time + 2.hours)

    # Need to be logged in
    login_as :quentin
  end

  def valid_attributes
    {:zone_name => "Wherever",
     :mob_name => "Whoever",
     :item_name => "Whatever",
     :player_name => "Me",
     :drop_time => @drop_time}
  end

  describe "GET index" do
    it "assigns all drops as @drops" do
      drop = Drop.create! valid_attributes
      get :index
      assigns(:drops).should eq([drop])
    end
  end

  describe "GET show" do
    it "assigns the requested drop as @drop" do
      drop = Drop.create! valid_attributes
      get :show, :id => drop.id.to_s
      assigns(:drop).should eq(drop)
    end
  end

  describe "GET new" do
    it "assigns a new drop as @drop" do
      get :new
      assigns(:drop).should be_a_new(Drop)
    end
  end

  describe "GET edit" do
    it "assigns the requested drop as @drop" do
      drop = Drop.create! valid_attributes
      get :edit, :id => drop.id.to_s
      assigns(:drop).should eq(drop)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Drop" do
        expect {
          post :create, :drop => valid_attributes
        }.to change(Drop, :count).by(1)
      end

      it "assigns a newly created drop as @drop" do
        post :create, :drop => valid_attributes
        assigns(:drop).should be_a(Drop)
        assigns(:drop).should be_persisted
      end

      it "redirects to the created drop" do
        post :create, :drop => valid_attributes
        response.should redirect_to(Drop.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved drop as @drop" do
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        post :create, :drop => {}
        assigns(:drop).should be_a_new(Drop)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        post :create, :drop => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested drop" do
        drop = Drop.create! valid_attributes
        # Assuming there are no other drops in the database, this
        # specifies that the Drop created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Drop.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => drop.id, :drop => {'these' => 'params'}
      end

      it "assigns the requested drop as @drop" do
        drop = Drop.create! valid_attributes
        put :update, :id => drop.id, :drop => valid_attributes
        assigns(:drop).should eq(drop)
      end

      it "redirects to the drop" do
        drop = Drop.create! valid_attributes
        put :update, :id => drop.id, :drop => valid_attributes
        response.should redirect_to(drop)
      end
    end

    describe "with invalid params" do
      it "assigns the drop as @drop" do
        drop = Drop.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        put :update, :id => drop.id.to_s, :drop => {}
        assigns(:drop).should eq(drop)
      end

      it "re-renders the 'edit' template" do
        drop = Drop.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        put :update, :id => drop.id.to_s, :drop => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested drop" do
      drop = Drop.create! valid_attributes
      expect {
        delete :destroy, :id => drop.id.to_s
      }.to change(Drop, :count).by(-1)
    end

    it "redirects to the drops list" do
      drop = Drop.create! valid_attributes
      delete :destroy, :id => drop.id.to_s
      response.should redirect_to(drops_url)
    end
  end

end
