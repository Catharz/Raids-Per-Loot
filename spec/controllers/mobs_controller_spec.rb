require 'spec_helper'

describe MobsController do
  fixtures :users

  before(:each) do
    login_as :quentin
  end

  describe 'GET index' do
    it 'assigns all mobs as @mobs' do
      mob = FactoryGirl.create(:mob)
      get :index
      assigns(:mobs).should eq([mob])
    end

    it 'filters by zone' do
      FactoryGirl.create(:mob)
      zone2 = FactoryGirl.create(:zone, :name => 'Somewhere Even Nastier')
      mob2 = FactoryGirl.create(:mob, :name => 'Tough Guy', :zone_id => zone2.id)

      get :index, :zone_id => zone2.id
      assigns(:mobs).should eq([mob2])
    end

    it 'filters by name' do
      FactoryGirl.create(:mob)
      mob2 = FactoryGirl.create(:mob, :name => 'Tough Guy')

      get :index, :name => 'Tough Guy'
      assigns(:mobs).should eq([mob2])
    end

    it 'renders xml' do
      mob = FactoryGirl.create(:mob)

      get :index, :format => :xml

      response.content_type.should eq('application/xml')
      response.body.should have_selector('mobs', :type => 'array') do |results|
        results.should have_selector('mob') do |pr|
          pr.should have_selector('id', type: 'integer', content: mob.id.to_s)
          pr.should have_selector('name', content: mob.name)
          pr.should have_selector('zone-id', type: 'integer', content: mob.zone_id.to_s)
          pr.should have_selector('difficulty-id', type: 'integer', content: mob.difficulty_id.to_s)
        end
      end
      response.body.should eq([mob].to_xml)
    end

    it 'renders json' do
      mob = FactoryGirl.create(:mob)

      get :index, :format => :json

      response.content_type.should eq('application/json')
      JSON.parse(response.body)[0].should eq JSON.parse(mob.to_json)
    end
  end

  describe 'GET #option_list' do
    it 'should populate an option list with sorted mob names' do
      mob1 = FactoryGirl.create(:mob)
      mob2 = FactoryGirl.create(:mob)
      get :option_list
      response.body.should eq('<option value=\'0\'>Select Mob</option>' +
                                  "<option value='#{mob1.id}'>#{mob1.name}</option>" +
                                  "<option value='#{mob2.id}'>#{mob2.name}</option>")
    end
  end

  describe 'GET show' do
    it 'assigns the requested mob as @mob' do
      mob = FactoryGirl.create(:mob)
      get :show, :id => mob
      assigns(:mob).should eq(mob)
    end
    it 'renders the :show template' do
      get :show, id: FactoryGirl.create(:mob)
      response.should render_template :show
    end

    it 'renders xml' do
      mob = FactoryGirl.create(:mob)

      get :show, format: :xml, id: mob.id

      response.content_type.should eq('application/xml')
      response.body.should eq(mob.to_xml)
    end

    it 'renders json' do
      mob = FactoryGirl.create(:mob)

      get :show, format: :json, id: mob

      response.content_type.should eq('application/json')
      JSON.parse(response.body).should eq JSON.parse(mob.to_json)
    end
  end

  describe 'GET new' do
    it 'assigns a new mob as @mob' do
      mob = Mob.new
      Mob.should_receive(:new).and_return(mob)
      get :new
      assigns(:mob).should eq(mob)
    end

    it 'renders the :new template' do
      get :new
      response.should render_template :new
    end
  end

  describe 'GET edit' do
    it 'assigns the requested mob as @mob' do
      mob = FactoryGirl.create(:mob)
      get :edit, :id => mob
      assigns(:mob).should eq(mob)
    end

    it 'renders the edit template' do
      mob = FactoryGirl.create(:mob)
      get :edit, :id => mob
      response.should render_template :edit
    end
  end

  describe 'POST create' do
    context 'with valid attributes' do
      it 'creates a new Mob' do
        expect {
          post :create, :mob => FactoryGirl.attributes_for(:mob)
        }.to change(Mob, :count).by(1)
      end

      it 'assigns a newly created mob as @mob' do
        post :create, :mob => FactoryGirl.attributes_for(:mob)
        assigns(:mob).should be_a(Mob)
        assigns(:mob).should be_persisted
      end

      it 'redirects to the new mob' do
        post :create, :mob => FactoryGirl.attributes_for(:mob)
        response.should redirect_to(Mob.last)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new mob' do
        expect {
          post :create, mob: FactoryGirl.attributes_for(:invalid_mob)
        }.to_not change(Mob, :count)
      end


      it 're-renders the :new template' do
        post :create, mob: FactoryGirl.attributes_for(:invalid_mob)
        response.should render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @mob = FactoryGirl.create(:mob, name: 'Whack-a-mole')
    end

    context 'with valid attributes' do
      it 'located the requested @mob' do
        put :update, id: @mob, mob: FactoryGirl.attributes_for(:mob)
        assigns(:mob).should eq (@mob)
      end

      it 'changes @mob''s attributes' do
        put :update, id: @mob, mob: @mob.attributes.merge!({name: 'Barney'})
        @mob.reload
        @mob.name.should eq('Barney')
      end

      it 'redirects to the updated @mob' do
        put :update, id: @mob, mob: @mob.attributes
        response.should redirect_to @mob
      end
    end

    context 'with invalid params' do
      it 'locates the requested @mob' do
        put :update, id: @mob, mob: FactoryGirl.attributes_for(:invalid_mob)
        assigns(:mob).should eq (@mob)
      end

      it 'does not change @mob''s attributes' do
        put :update, id: @mob, mob: FactoryGirl.attributes_for(:invalid_mob)
        @mob.reload
        @mob.name.should_not be_nil
      end

      it 're-renders the :edit template' do
        put :update, id: @mob, mob: FactoryGirl.attributes_for(:invalid_mob)
        response.should render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @mob = FactoryGirl.create(:mob)
    end

    it 'deletes the mob' do
      expect {
        delete :destroy, :id => @mob
      }.to change(Mob, :count).by(-1)
    end

    it 'redirects mobs#index' do
      delete :destroy, :id => @mob
      response.should redirect_to mobs_url
    end
  end

end
