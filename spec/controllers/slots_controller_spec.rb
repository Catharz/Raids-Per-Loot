require 'spec_helper'
require 'authentication_spec_helper'

describe SlotsController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  def valid_attributes
    {name: "Primary"}
  end

  describe "GET index" do
    it "assigns all slots as @slots" do
      slot = Slot.create! valid_attributes
      get :index
      assigns(:slots).should eq([slot])
    end
  end

  describe "GET show" do
    it "assigns the requested slot as @slot" do
      slot = Slot.create! valid_attributes
      get :show, id: slot.id.to_s
      assigns(:slot).should eq(slot)
    end
  end

  describe "GET new" do
    it "assigns a new slot as @slot" do
      get :new
      assigns(:slot).should be_a_new(Slot)
    end
  end

  describe "GET edit" do
    it "assigns the requested slot as @slot" do
      slot = Slot.create! valid_attributes
      get :edit, id: slot.id.to_s
      assigns(:slot).should eq(slot)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Slot" do
        expect {
          post :create, slot: valid_attributes
        }.to change(Slot, :count).by(1)
      end

      it "assigns a newly created slot as @slot" do
        post :create, slot: valid_attributes
        assigns(:slot).should be_a(Slot)
        assigns(:slot).should be_persisted
      end

      it "redirects to the created slot" do
        post :create, slot: valid_attributes
        response.should redirect_to(Slot.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved slot as @slot" do
        # Trigger the behavior that occurs when invalid params are submitted
        Slot.any_instance.stub(:save).and_return(false)
        post :create, slot: {}
        assigns(:slot).should be_a_new(Slot)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Slot.any_instance.stub(:save).and_return(false)
        post :create, slot: {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested slot" do
        slot = Slot.create! valid_attributes
        # Assuming there are no other slots in the database, this
        # specifies that the Slot created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Slot.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, id: slot.id, slot: {'these' => 'params'}
      end

      it "assigns the requested slot as @slot" do
        slot = Slot.create! valid_attributes
        put :update, id: slot.id, slot: valid_attributes
        assigns(:slot).should eq(slot)
      end

      it "redirects to the slot" do
        slot = Slot.create! valid_attributes
        put :update, id: slot.id, slot: valid_attributes
        response.should redirect_to(slot)
      end
    end

    describe "with invalid params" do
      it "assigns the slot as @slot" do
        slot = Slot.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Slot.any_instance.stub(:save).and_return(false)
        put :update, id: slot.id.to_s, slot: {}
        assigns(:slot).should eq(slot)
      end

      it "re-renders the 'edit' template" do
        slot = Slot.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Slot.any_instance.stub(:save).and_return(false)
        put :update, id: slot.id.to_s, slot: {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested slot" do
      slot = Slot.create! valid_attributes
      expect {
        delete :destroy, id: slot.id.to_s
      }.to change(Slot, :count).by(-1)
    end

    it "redirects to the slots list" do
      slot = Slot.create! valid_attributes
      delete :destroy, id: slot.id.to_s
      response.should redirect_to(slots_url)
    end
  end

end
