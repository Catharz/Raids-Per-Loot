require 'spec_helper'
require 'authentication_spec_helper'

describe AdjustmentsController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    # Need to be logged in
    login_as :admin
  end

  describe 'GET index' do
    it 'assigns all adjustments as @adjustments' do
      adjustment = Adjustment.create! FactoryGirl.attributes_for(:adjustment)
      get :index, {}
      assigns(:adjustments).should eq([adjustment])
    end
  end

  describe 'GET show' do
    it 'assigns the requested adjustment as @adjustment' do
      adjustment = Adjustment.create! FactoryGirl.attributes_for(:adjustment)
      get :show, {id: adjustment.to_param}
      assigns(:adjustment).should eq(adjustment)
    end
  end

  describe 'GET new' do
    it 'assigns a new adjustment as @adjustment' do
      get :new, {}
      assigns(:adjustment).should be_a_new(Adjustment)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested adjustment as @adjustment' do
      adjustment = Adjustment.create! FactoryGirl.attributes_for(:adjustment)
      get :edit, {id: adjustment.to_param}
      assigns(:adjustment).should eq(adjustment)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Adjustment' do
        expect {
          post :create, {adjustment: FactoryGirl.attributes_for(:adjustment)}
        }.to change(Adjustment, :count).by(1)
      end

      it 'assigns a newly created adjustment as @adjustment' do
        post :create, {adjustment: FactoryGirl.attributes_for(:adjustment)}
        assigns(:adjustment).should be_a(Adjustment)
        assigns(:adjustment).should be_persisted
      end

      it 'redirects to the created adjustment' do
        post :create, {adjustment: FactoryGirl.attributes_for(:adjustment)}
        response.should redirect_to(Adjustment.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved adjustment as @adjustment' do
        # Trigger the behavior that occurs when invalid params are submitted
        Adjustment.any_instance.stub(:save).and_return(false)
        post :create, {adjustment: {}}
        assigns(:adjustment).should be_a_new(Adjustment)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Adjustment.any_instance.stub(:save).and_return(false)
        post :create, {adjustment: {}}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested adjustment' do
        adjustment = Adjustment.create! FactoryGirl.attributes_for(:adjustment)
        # Assuming there are no other adjustments in the database, this
        # specifies that the Adjustment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Adjustment.any_instance.should_receive(:update_attributes).
            with({'these' => 'params'})
        put :update, {id: adjustment.to_param,
                      adjustment: {'these' => 'params'}}
      end

      it 'assigns the requested adjustment as @adjustment' do
        adjustment = Adjustment.create! FactoryGirl.attributes_for(:adjustment)
        put :update, {id: adjustment.to_param,
                      adjustment: FactoryGirl.attributes_for(:adjustment)}
        assigns(:adjustment).should eq(adjustment)
      end

      it 'redirects to the adjustment' do
        adjustment = Adjustment.create! FactoryGirl.attributes_for(:adjustment)
        put :update, {id: adjustment.to_param,
                      adjustment: FactoryGirl.attributes_for(:adjustment)}
        response.should redirect_to(adjustment)
      end
    end

    describe 'with invalid params' do
      it 'assigns the adjustment as @adjustment' do
        adjustment = Adjustment.create! FactoryGirl.attributes_for(:adjustment)
        # Trigger the behavior that occurs when invalid params are submitted
        Adjustment.any_instance.stub(:save).and_return(false)
        put :update, {id: adjustment.to_param, adjustment: {}}
        assigns(:adjustment).should eq(adjustment)
      end

      it "re-renders the 'edit' template" do
        adjustment = Adjustment.create! FactoryGirl.attributes_for(:adjustment)
        # Trigger the behavior that occurs when invalid params are submitted
        Adjustment.any_instance.stub(:save).and_return(false)
        put :update, {id: adjustment.to_param, adjustment: {}}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested adjustment' do
      adjustment = Adjustment.create! FactoryGirl.attributes_for(:adjustment)
      expect {
        delete :destroy, {id: adjustment.to_param}
      }.to change(Adjustment, :count).by(-1)
    end

    it 'redirects to the adjustments list' do
      adjustment = Adjustment.create! FactoryGirl.attributes_for(:adjustment)
      delete :destroy, {id: adjustment.to_param}
      response.should redirect_to(adjustments_url)
    end
  end
end