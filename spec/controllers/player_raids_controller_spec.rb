require 'spec_helper'
require 'authentication_spec_helper'

describe PlayerRaidsController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  describe 'GET #index' do
    it 'populates a collection of difficulties' do
      player_raid = FactoryGirl.create(:player_raid)

      get :index

      assigns(:player_raids).should eq([player_raid])
    end

    it 'renders the :index view' do
      get :index
      response.should render_template :index
    end

    it 'renders xml' do
      player_raid = FactoryGirl.create(:player_raid)

      get :index, format: :xml

      response.content_type.should eq('application/xml')
      response.body.
          should have_selector('player-raids', type: 'array') do |results|
        results.should have_selector('player-raid') do |pr|
          pr.should have_selector('raid-id', type: 'integer',
                                  content: player_raid.raid_id.to_s)
          pr.should have_selector('player-id', type: 'integer',
                                  content: player_raid.player_id.to_s)
        end
      end
      response.body.should eq([player_raid].to_xml)
    end

    it 'renders json' do
      player_raid = FactoryGirl.create(:player_raid)

      get :index, format: :json

      response.content_type.should eq('application/json')
      JSON.parse(response.body).should include(player_raid.as_json)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested player_raid to @player_raid' do
      player_raid = FactoryGirl.create(:player_raid)

      get :show, id: player_raid

      assigns(:player_raid).should eq(player_raid)
    end

    it 'renders the :show template' do
      get :show, id: FactoryGirl.create(:player_raid)
      response.should render_template :show
    end

    it 'renders xml' do
      player_raid = FactoryGirl.create(:player_raid)

      get :show, format: :xml, id: player_raid.id

      response.content_type.should eq('application/xml')
      response.body.should eq(player_raid.to_xml)
    end

    it 'renders json' do
      player_raid = FactoryGirl.create(:player_raid)

      get :show, format: :json, id: player_raid

      response.content_type.should eq('application/json')
      JSON.parse(response.body).should eq(player_raid.as_json)
    end
  end

  describe 'GET new' do
    it 'assigns a new player_raid as @player_raid' do
      get :new, {}
      assigns(:player_raid).should be_a_new(PlayerRaid)
    end

    it 'renders the :new template' do
      get :new
      response.should render_template :new
    end
  end

  describe 'GET edit' do
    it 'assigns the requested player_raid as @player_raid' do
      player_raid =
          PlayerRaid.create! FactoryGirl.build(:player_raid).
                                 attributes.symbolize_keys
      get :edit, {id: player_raid.to_param}
      assigns(:player_raid).should eq(player_raid)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new PlayerRaid' do
        expect {
          post :create, {player_raid: FactoryGirl.
              build(:player_raid).attributes.symbolize_keys}
        }.to change(PlayerRaid, :count).by(1)
      end

      it 'assigns a newly created player_raid as @player_raid' do
        post :create, {player_raid: FactoryGirl.
            build(:player_raid).attributes.symbolize_keys}
        assigns(:player_raid).should be_a(PlayerRaid)
        assigns(:player_raid).should be_persisted
      end

      it 'redirects to the created player_raid' do
        post :create, {player_raid: FactoryGirl.
            build(:player_raid).attributes.symbolize_keys}
        response.should redirect_to(PlayerRaid.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved player_raid as @player_raid' do
        PlayerRaid.any_instance.stub(:save).and_return(false)
        post :create, {player_raid: {}}
        assigns(:player_raid).should be_a_new(PlayerRaid)
      end

      it "re-renders the 'new' template" do
        PlayerRaid.any_instance.stub(:save).and_return(false)
        post :create, {player_raid: {}}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested player_raid' do
        player_raid =
            PlayerRaid.create! FactoryGirl.build(:player_raid).
                                   attributes.symbolize_keys
        PlayerRaid.any_instance.should_receive(:update_attributes).
            with({'these' => 'params'})
        put :update, {id: player_raid.to_param,
                      player_raid: {'these' => 'params'}}
      end

      it 'assigns the requested player_raid as @player_raid' do
        player_raid = PlayerRaid.create! FactoryGirl.build(:player_raid).
                                             attributes.symbolize_keys
        put :update, {id: player_raid.to_param,
                      player_raid: FactoryGirl.build(:player_raid).
                          attributes.symbolize_keys}
        assigns(:player_raid).should eq(player_raid)
      end

      it 'redirects to the player_raid' do
        player_raid = PlayerRaid.create! FactoryGirl.build(:player_raid).
                                             attributes.symbolize_keys
        put :update, {id: player_raid.to_param,
                      player_raid: FactoryGirl.build(:player_raid).
                          attributes.symbolize_keys}
        response.should redirect_to(player_raid)
      end
    end

    describe 'with invalid params' do
      it 'assigns the player_raid as @player_raid' do
        player_raid = PlayerRaid.create! FactoryGirl.build(:player_raid).
                                             attributes.symbolize_keys
        PlayerRaid.any_instance.stub(:save).and_return(false)
        put :update, {id: player_raid.to_param, player_raid: {}}
        assigns(:player_raid).should eq(player_raid)
      end

      it "re-renders the 'edit' template" do
        player_raid = PlayerRaid.create! FactoryGirl.build(:player_raid).
                                             attributes.symbolize_keys
        PlayerRaid.any_instance.stub(:save).and_return(false)
        put :update, {id: player_raid.to_param, player_raid: {}}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested player_raid' do
      player_raid = PlayerRaid.create! FactoryGirl.build(:player_raid).
                                           attributes.symbolize_keys
      expect {
        delete :destroy, {id: player_raid.to_param}
      }.to change(PlayerRaid, :count).by(-1)
    end

    it 'redirects to the player_raids list' do
      player_raid = PlayerRaid.create! FactoryGirl.build(:player_raid).
                                           attributes.symbolize_keys
      delete :destroy, {id: player_raid.to_param}
      response.should redirect_to(player_raids_url)
    end
  end
end