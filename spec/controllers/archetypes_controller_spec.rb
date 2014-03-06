require 'spec_helper'
require 'authentication_spec_helper'

describe ArchetypesController do
  include AuthenticationSpecHelper
  fixtures :users, :services, :archetypes

  before(:each) do
    login_as :admin
  end

  describe 'GET index' do
    it 'assigns all archetypes as @archetypes' do
      archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
      get :index
      assigns(:archetypes).should include archetype
    end

    it 'returns JSON' do
      archetypes = Archetype.all
      get :index, format: :json
      result = JSON.parse(response.body)
      result.should eq archetypes.collect { |a| JSON.parse(a.to_json(methods: [:parent_name, :root_name])) }
    end

    it 'returns XML' do
      archetypes = Archetype.all
      get :index, format: :xml
      response.body.should have_xpath '//archetypes/*[1]/name'
      response.body.should have_content archetypes.first.name
    end
  end

  describe 'GET show' do
    it 'assigns the requested archetype as @archetype' do
      archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
      get :show, id: archetype.id.to_s
      assigns(:archetype).should eq(archetype)
    end

    it 'returns JSON' do
      archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
      get :show, id: archetype, format: :json
      result = JSON.parse(response.body)
      result.should eq JSON.parse(archetype.to_json(methods: [:parent_name, :root_name]))
    end

    it 'returns XML' do
      archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
      get :show, id: archetype, format: :xml
      response.body.should have_xpath '//archetype/name'
      response.body.should have_content archetype.name
    end
  end

  describe 'GET new' do
    it 'assigns a new archetype as @archetype' do
      get :new
      assigns(:archetype).should be_a_new(Archetype)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested archetype as @archetype' do
      archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
      get :edit, id: archetype.id.to_s
      assigns(:archetype).should eq(archetype)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Archetype' do
        expect {
          post :create, archetype: FactoryGirl.attributes_for(:archetype)
        }.to change(Archetype, :count).by(1)
      end

      it 'assigns a newly created archetype as @archetype' do
        post :create, archetype: FactoryGirl.attributes_for(:archetype)
        assigns(:archetype).should be_a(Archetype)
        assigns(:archetype).should be_persisted
      end

      it 'redirects to the created archetype' do
        post :create, archetype: FactoryGirl.attributes_for(:archetype)
        response.should redirect_to(Archetype.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved archetype as @archetype' do
        # Trigger the behavior that occurs when invalid params are submitted
        Archetype.any_instance.stub(:save).and_return(false)
        post :create, archetype: {}
        assigns(:archetype).should be_a_new(Archetype)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Archetype.any_instance.stub(:save).and_return(false)
        post :create, archetype: {}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested archetype' do
        archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
        # Assuming there are no other archetypes in the database, this
        # specifies that the Archetype created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Archetype.any_instance.should_receive(:update_attributes).
            with({'these' => 'params'})
        put :update, id: archetype.id, archetype: {'these' => 'params'}
      end

      it 'assigns the requested archetype as @archetype' do
        archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
        put :update, id: archetype.id,
            archetype: FactoryGirl.attributes_for(:archetype)
        assigns(:archetype).should eq(archetype)
      end

      it 'redirects to the archetype' do
        archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
        put :update, id: archetype.id,
            archetype: FactoryGirl.attributes_for(:archetype)
        response.should redirect_to(archetype)
      end
    end

    describe 'with invalid params' do
      it 'assigns the archetype as @archetype' do
        archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
        # Trigger the behavior that occurs when invalid params are submitted
        Archetype.any_instance.stub(:save).and_return(false)
        put :update, id: archetype.id.to_s, archetype: {}
        assigns(:archetype).should eq(archetype)
      end

      it "re-renders the 'edit' template" do
        archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
        # Trigger the behavior that occurs when invalid params are submitted
        Archetype.any_instance.stub(:save).and_return(false)
        put :update, id: archetype.id.to_s, archetype: {}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested archetype' do
      archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
      expect {
        delete :destroy, id: archetype.id.to_s
      }.to change(Archetype, :count).by(-1)
    end

    it 'redirects to the archetypes list' do
      archetype = Archetype.create! FactoryGirl.attributes_for(:archetype)
      delete :destroy, id: archetype.id.to_s
      response.should redirect_to(archetypes_url)
    end
  end
end
