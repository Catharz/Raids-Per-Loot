require 'spec_helper'
require 'authentication_spec_helper'

describe AdjustmentsController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    # Need to be logged in
    login_as :admin
  end

  def valid_attributes
    rank = Rank.create(:name => "Main")
    player = Player.create(:name => "Fred", :rank_id => rank.id)
    character = Character.create(:name => "Fred", :char_type => "m", :player_id => player.id)
    {:adjustment_type => "Raids",
     :amount => 5,
     :reason => "Ok Switch",
     :adjustable_id => character.id,
     :adjustable_type => "Character"}
  end

  def valid_session
    {:user_id => 1,
    :session_id => "5483b7900fad9e6f76dada9917f6faed",
    :_csrf_token => "FXpTMzh2nkiWtdWserY5IYgGHjQTv/MA3ISZxcj0TVU="}
  end

  describe "GET index" do
    it "assigns all adjustments as @adjustments" do
      adjustment = Adjustment.create! valid_attributes
      get :index, {}, valid_session
      assigns(:adjustments).should eq([adjustment])
    end
  end

  describe "GET show" do
    it "assigns the requested adjustment as @adjustment" do
      adjustment = Adjustment.create! valid_attributes
      get :show, {:id => adjustment.to_param}, valid_session
      assigns(:adjustment).should eq(adjustment)
    end
  end

  describe "GET new" do
    it "assigns a new adjustment as @adjustment" do
      get :new, {}, valid_session
      assigns(:adjustment).should be_a_new(Adjustment)
    end
  end

  describe "GET edit" do
    it "assigns the requested adjustment as @adjustment" do
      adjustment = Adjustment.create! valid_attributes
      get :edit, {:id => adjustment.to_param}, valid_session
      assigns(:adjustment).should eq(adjustment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Adjustment" do
        expect {
          post :create, {:adjustment => valid_attributes}, valid_session
        }.to change(Adjustment, :count).by(1)
      end

      it "assigns a newly created adjustment as @adjustment" do
        post :create, {:adjustment => valid_attributes}, valid_session
        assigns(:adjustment).should be_a(Adjustment)
        assigns(:adjustment).should be_persisted
      end

      it "redirects to the created adjustment" do
        post :create, {:adjustment => valid_attributes}, valid_session
        response.should redirect_to(Adjustment.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved adjustment as @adjustment" do
        # Trigger the behavior that occurs when invalid params are submitted
        Adjustment.any_instance.stub(:save).and_return(false)
        post :create, {:adjustment => {}}, valid_session
        assigns(:adjustment).should be_a_new(Adjustment)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Adjustment.any_instance.stub(:save).and_return(false)
        post :create, {:adjustment => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested adjustment" do
        adjustment = Adjustment.create! valid_attributes
        # Assuming there are no other adjustments in the database, this
        # specifies that the Adjustment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Adjustment.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => adjustment.to_param, :adjustment => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested adjustment as @adjustment" do
        adjustment = Adjustment.create! valid_attributes
        put :update, {:id => adjustment.to_param, :adjustment => valid_attributes}, valid_session
        assigns(:adjustment).should eq(adjustment)
      end

      it "redirects to the adjustment" do
        adjustment = Adjustment.create! valid_attributes
        put :update, {:id => adjustment.to_param, :adjustment => valid_attributes}, valid_session
        response.should redirect_to(adjustment)
      end
    end

    describe "with invalid params" do
      it "assigns the adjustment as @adjustment" do
        adjustment = Adjustment.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Adjustment.any_instance.stub(:save).and_return(false)
        put :update, {:id => adjustment.to_param, :adjustment => {}}, valid_session
        assigns(:adjustment).should eq(adjustment)
      end

      it "re-renders the 'edit' template" do
        adjustment = Adjustment.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Adjustment.any_instance.stub(:save).and_return(false)
        put :update, {:id => adjustment.to_param, :adjustment => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested adjustment" do
      adjustment = Adjustment.create! valid_attributes
      expect {
        delete :destroy, {:id => adjustment.to_param}, valid_session
      }.to change(Adjustment, :count).by(-1)
    end

    it "redirects to the adjustments list" do
      adjustment = Adjustment.create! valid_attributes
      delete :destroy, {:id => adjustment.to_param}, valid_session
      response.should redirect_to(adjustments_url)
    end
  end

end
