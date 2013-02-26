require 'spec_helper'

describe CharacterTypesController do
  fixtures :users

  before(:each) do
    login_as :quentin
  end

  describe 'GET #index' do
    it 'populates a collection of character_types' do
      character_type = FactoryGirl.create(:character_type)
      get :index
      assigns(:character_types).should eq([character_type])
    end

    it 'renders the :index view' do
      get :index
      response.should render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested character_type to @character_type' do
      character_type = FactoryGirl.create(:character_type)
      get :show, id: character_type
      assigns(:character_type).should eq(character_type)
    end

    it 'renders the :show template' do
      get :show, id: FactoryGirl.create(:character_type)
      response.should render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new character_type to @character_type' do
      character_type = CharacterType.new
      CharacterType.should_receive(:new).and_return(character_type)
      get :new
      assigns(:character_type).should eq(character_type)
    end

    it 'renders the :new template' do
      get :new
      response.should render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new character_type' do
        expect {
          post :create, character_type: FactoryGirl.attributes_for(:character_type)
        }.to change(CharacterType, :count).by(1)
      end

      it 'redirects to the new character_type' do
        post :create, character_type: FactoryGirl.attributes_for(:character_type)
        response.should redirect_to CharacterType.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new character_type' do
        expect {
          post :create, character_type: FactoryGirl.attributes_for(:invalid_character_type)
        }.to_not change(CharacterType, :count)
      end

      it 're-renders the :new template' do
        post :create, character_type: FactoryGirl.attributes_for(:invalid_character_type)
        response.should render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @character_type = FactoryGirl.create(:character_type, char_type: 'r', effective_date: Time.now)
    end

    context 'valid attributes' do
      it 'located the requested @character_type' do
        put :update, id: @character_type, character_type: FactoryGirl.attributes_for(:character_type)
        assigns(:character_type).should eq (@character_type)
      end

      it "changes @character_type's attributes" do
        effective = Date.parse("01/01/2013")
        put :update, id: @character_type,
            character_type: FactoryGirl.attributes_for(:character_type, char_type: 'r', effective_date: effective)
        @character_type.reload
        @character_type.char_type.should eq('r')
        @character_type.effective_date.should eq(effective)
      end

      it 'redirects to the updated @character_type' do
        put :update, id: @character_type, character_type: FactoryGirl.attributes_for(:character_type)
        response.should redirect_to @character_type
      end
    end

    context 'invalid attributes' do
      it 'locates the requested @character_type' do
        put :update, id: @character_type, character_type: FactoryGirl.attributes_for(:invalid_character_type)
        assigns(:character_type).should eq (@character_type)
      end

      it "does not change @character_type's attributes" do
        put :update, id: @character_type,
            character_type: FactoryGirl.attributes_for(:character_type, char_type: 'f', normal_penalty: 10)
        @character_type.reload
        @character_type.char_type.should_not eq('f')
        @character_type.normal_penalty.should eq(0)
      end

      it 're-renders the :edit template' do
        put :update, id: @character_type, character_type: FactoryGirl.attributes_for(:invalid_character_type)
        response.should render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @character_type = FactoryGirl.create(:character_type)
    end

    it 'deletes the character_type' do
      expect {
        delete :destroy, id: @character_type
      }.to change(CharacterType, :count).by(-1)
    end

    it 'redirects to character_types#index' do
      delete :destroy, id: @character_type
      response.should redirect_to character_types_url
    end
  end
end