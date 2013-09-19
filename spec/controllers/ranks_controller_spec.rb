require 'spec_helper'
require 'authentication_spec_helper'

describe RanksController do
  include AuthenticationSpecHelper
  fixtures :users, :services, :ranks

  before(:each) do
    login_as :admin
  end

  describe 'GET index' do
    it 'assigns all ranks as @ranks' do
      rank = Rank.create! FactoryGirl.attributes_for(:rank)
      get :index
      assigns(:ranks).should include rank
    end

    it 'responds with JSON' do
      get :index, format: :json

      response.body.should eq Rank.order(:priority).to_json
    end

    it 'responds with XML' do
      get :index, format: :xml

      response.body.should eq Rank.order(:priority).to_xml
    end
  end

  describe 'GET show' do
    it 'assigns the requested rank as @rank' do
      rank = Rank.create! FactoryGirl.attributes_for(:rank)
      get :show, id: rank.id.to_s
      assigns(:rank).should eq(rank)
    end

    it 'responds with JSON' do
      rank = Rank.first
      get :show, id: rank, format: :json
      response.body.should eq rank.to_json
    end

    it 'responds with XML' do
      rank = Rank.last
      get :show, id: rank, format: :xml
      response.body.should eq rank.to_xml
    end
  end

  describe 'GET new' do
    it 'assigns a new rank as @rank' do
      get :new
      assigns(:rank).should be_a_new(Rank)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested rank as @rank' do
      rank = Rank.create! FactoryGirl.attributes_for(:rank)
      get :edit, id: rank.id.to_s
      assigns(:rank).should eq(rank)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Rank' do
        expect {
          post :create, rank: FactoryGirl.attributes_for(:rank)
        }.to change(Rank, :count).by(1)
      end

      it 'assigns a newly created rank as @rank' do
        post :create, rank: FactoryGirl.attributes_for(:rank)
        assigns(:rank).should be_a(Rank)
        assigns(:rank).should be_persisted
      end

      it 'redirects to the created rank' do
        post :create, rank: FactoryGirl.attributes_for(:rank)
        response.should redirect_to(Rank.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved rank as @rank' do
        # Trigger the behavior that occurs when invalid params are submitted
        Rank.any_instance.stub(:save).and_return(false)
        post :create, rank: {}
        assigns(:rank).should be_a_new(Rank)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Rank.any_instance.stub(:save).and_return(false)
        post :create, rank: {}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested rank' do
        rank = Rank.create! FactoryGirl.attributes_for(:rank)
        # Assuming there are no other ranks in the database, this
        # specifies that the Rank created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Rank.any_instance.should_receive(:update_attributes).
            with({'these' => 'params'})
        put :update, id: rank.id, rank: {'these' => 'params'}
      end

      it 'assigns the requested rank as @rank' do
        rank = Rank.create! FactoryGirl.attributes_for(:rank)
        put :update, id: rank.id, rank: FactoryGirl.attributes_for(:rank)
        assigns(:rank).should eq(rank)
      end

      it 'redirects to the rank' do
        rank = Rank.create! FactoryGirl.attributes_for(:rank)
        put :update, id: rank.id, rank: FactoryGirl.attributes_for(:rank)
        response.should redirect_to(rank)
      end
    end

    describe 'with invalid params' do
      it 'assigns the rank as @rank' do
        rank = Rank.create! FactoryGirl.attributes_for(:rank)
        # Trigger the behavior that occurs when invalid params are submitted
        Rank.any_instance.stub(:save).and_return(false)
        put :update, id: rank.id.to_s, rank: {}
        assigns(:rank).should eq(rank)
      end

      it "re-renders the 'edit' template" do
        rank = Rank.create! FactoryGirl.attributes_for(:rank)
        # Trigger the behavior that occurs when invalid params are submitted
        Rank.any_instance.stub(:save).and_return(false)
        put :update, id: rank.id.to_s, rank: {}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested rank' do
      rank = Rank.create! FactoryGirl.attributes_for(:rank)
      expect {
        delete :destroy, id: rank.id.to_s
      }.to change(Rank, :count).by(-1)
    end

    it 'redirects to the ranks list' do
      rank = Rank.create! FactoryGirl.attributes_for(:rank)
      delete :destroy, id: rank.id.to_s
      response.should redirect_to(ranks_url)
    end
  end

end
