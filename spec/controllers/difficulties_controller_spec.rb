require 'spec_helper'
require 'authentication_spec_helper'

describe DifficultiesController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  describe 'GET #index' do
    it 'populates a collection of difficulties' do
      difficulty = FactoryGirl.create(:difficulty)
      get :index
      assigns(:difficulties).should eq([difficulty])
    end

    it 'renders the :index view' do
      get :index
      response.should render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested difficulty to @difficulty' do
      difficulty = FactoryGirl.create(:difficulty)
      get :show, id: difficulty
      assigns(:difficulty).should eq(difficulty)
    end

    it 'renders the :show template' do
      get :show, id: FactoryGirl.create(:difficulty)
      response.should render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new difficulty to @difficulty' do
      difficulty = Difficulty.new
      Difficulty.should_receive(:new).and_return(difficulty)
      get :new
      assigns(:difficulty).should eq(difficulty)
    end

    it 'renders the :new template' do
      get :new
      response.should render_template :new
    end
  end

  describe 'GET edit' do
    it 'assigns the requested difficulty as @difficulty' do
      difficulty = Difficulty.create! FactoryGirl.attributes_for(:difficulty)
      get :edit, id: difficulty.id.to_s
      assigns(:difficulty).should eq(difficulty)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new difficulty' do
        expect {
          post :create, difficulty: FactoryGirl.attributes_for(:difficulty)
        }.to change(Difficulty, :count).by(1)
      end

      it 'redirects to the new difficulty' do
        post :create, difficulty: FactoryGirl.attributes_for(:difficulty)
        response.should redirect_to Difficulty.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new difficulty' do
        expect {
          post :create, difficulty: FactoryGirl.
              attributes_for(:invalid_difficulty)
        }.to_not change(Difficulty, :count)
      end

      it 're-renders the :new template' do
        post :create, difficulty: FactoryGirl.
            attributes_for(:invalid_difficulty)
        response.should render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @difficulty = FactoryGirl.create(:difficulty, name: 'Extreme', rating: 10)
    end

    context 'valid attributes' do
      it 'located the requested @difficulty' do
        put :update, id: @difficulty,
            difficulty: FactoryGirl.attributes_for(:difficulty)
        assigns(:difficulty).should eq (@difficulty)
      end

      it "changes @difficulty's attributes" do
        put :update, id: @difficulty,
            difficulty: FactoryGirl.attributes_for(:difficulty,
                                                   name: 'Super Hard',
                                                   rating: 9)
        @difficulty.reload
        @difficulty.name.should eq('Super Hard')
        @difficulty.rating.should eq(9)
      end

      it 'redirects to the updated @difficulty' do
        put :update, id: @difficulty,
            difficulty: FactoryGirl.attributes_for(:difficulty)
        response.should redirect_to @difficulty
      end
    end

    context 'invalid attributes' do
      it 'locates the requested @difficulty' do
        put :update, id: @difficulty,
            difficulty: FactoryGirl.attributes_for(:invalid_difficulty)
        assigns(:difficulty).should eq (@difficulty)
      end

      it "does not change @difficulty's attributes" do
        put :update, id: @difficulty,
            difficulty: FactoryGirl.attributes_for(:difficulty,
                                                   name: 'Whatever',
                                                   rating: nil)
        @difficulty.reload
        @difficulty.name.should_not eq('Whatever')
        @difficulty.rating.should eq(10)
      end

      it 're-renders the :edit template' do
        put :update, id: @difficulty,
            difficulty: FactoryGirl.attributes_for(:invalid_difficulty)
        response.should render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @difficulty = FactoryGirl.create(:difficulty)
    end

    it 'deletes the difficulty' do
      expect {
        delete :destroy, id: @difficulty
      }.to change(Difficulty, :count).by(-1)
    end

    it 'redirects to difficulties#index' do
      delete :destroy, id: @difficulty
      response.should redirect_to difficulties_url
    end
  end
end