require 'spec_helper'

describe MobsController do
  fixtures :users

  before(:each) do
    login_as :quentin
    @zone = FactoryGirl.create(:zone, :name => 'Somewhere Nasty')
  end

  def valid_attributes
    {:name => "Whoever", :zone_id => @zone.id}
  end

  describe "GET index" do
    it "assigns all mobs as @mobs" do
      mob = FactoryGirl.create(:mob, valid_attributes)
      get :index
      assigns(:mobs).should eq([mob])
    end

    it "filters by zone" do
      FactoryGirl.create(:mob, valid_attributes)
      zone2 = FactoryGirl.create(:zone, :name => 'Somewhere Even Nastier')
      mob2 = FactoryGirl.create(:mob, :name => 'Tough Guy', :zone_id => zone2.id)

      get :index, :zone_id => zone2.id
      assigns(:mobs).should eq([mob2])
    end

    it "filters by name" do
      FactoryGirl.create(:mob, valid_attributes)
      zone2 = FactoryGirl.create(:zone, :name => 'Somewhere Even Nastier')
      mob2 = FactoryGirl.create(:mob, :name => 'Tough Guy', :zone_id => zone2.id)

      get :index, :name => 'Tough Guy'
      assigns(:mobs).should eq([mob2])
    end
  end

  describe "GET show" do
    it "assigns the requested mob as @mob" do
      mob = FactoryGirl.create(:mob, valid_attributes)
      get :show, :id => mob.id.to_s
      assigns(:mob).should eq(mob)
    end
  end

  describe "GET new" do
    it "assigns a new mob as @mob" do
      get :new
      assigns(:mob).should be_a_new(Mob)
    end
  end

  describe "GET edit" do
    it "assigns the requested mob as @mob" do
      mob = FactoryGirl.create(:mob, valid_attributes)
      get :edit, :id => mob.id.to_s
      assigns(:mob).should eq(mob)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Mob" do
        expect {
          post :create, :mob => valid_attributes
        }.to change(Mob, :count).by(1)
      end

      it "assigns a newly created mob as @mob" do
        post :create, :mob => valid_attributes
        assigns(:mob).should be_a(Mob)
        assigns(:mob).should be_persisted
      end

      it "redirects to the created mob" do
        post :create, :mob => valid_attributes
        response.should redirect_to(Mob.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved mob as @mob" do
        # Trigger the behavior that occurs when invalid params are submitted
        Mob.any_instance.stub(:save).and_return(false)
        post :create, :mob => {}
        assigns(:mob).should be_a_new(Mob)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Mob.any_instance.stub(:save).and_return(false)
        post :create, :mob => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested mob" do
        mob = FactoryGirl.create(:mob, valid_attributes)
        # Assuming there are no other mobs in the database, this
        # specifies that the Mob created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Mob.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => mob.id, :mob => {'these' => 'params'}
      end

      it "assigns the requested mob as @mob" do
        mob = FactoryGirl.create(:mob, valid_attributes)
        put :update, :id => mob.id, :mob => valid_attributes
        assigns(:mob).should eq(mob)
      end

      it "redirects to the mob" do
        mob = FactoryGirl.create(:mob, valid_attributes)
        put :update, :id => mob.id, :mob => valid_attributes
        response.should redirect_to(mob)
      end
    end

    describe "with invalid params" do
      it "assigns the mob as @mob" do
        mob = FactoryGirl.create(:mob, valid_attributes)
        # Trigger the behavior that occurs when invalid params are submitted
        Mob.any_instance.stub(:save).and_return(false)
        put :update, :id => mob.id.to_s, :mob => {}
        assigns(:mob).should eq(mob)
      end

      it "re-renders the 'edit' template" do
        mob = FactoryGirl.create(:mob, valid_attributes)
        # Trigger the behavior that occurs when invalid params are submitted
        Mob.any_instance.stub(:save).and_return(false)
        put :update, :id => mob.id.to_s, :mob => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested mob" do
      mob = FactoryGirl.create(:mob, valid_attributes)
      expect {
        delete :destroy, :id => mob.id.to_s
      }.to change(Mob, :count).by(-1)
    end

    it "redirects to the mobs list" do
      mob = FactoryGirl.create(:mob, valid_attributes)
      delete :destroy, :id => mob.id.to_s
      response.should redirect_to(mobs_url)
    end
  end

end
