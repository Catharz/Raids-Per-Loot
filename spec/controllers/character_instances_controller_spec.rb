require 'spec_helper'
require 'authentication_spec_helper'

describe CharacterInstancesController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin

    @char1 = FactoryGirl.create(:character, name: 'character 1')
    @char2 = FactoryGirl.create(:character, name: 'character 2')

    progression = FactoryGirl.create(:raid_type, name: 'Progression')
    raid = FactoryGirl.create(:raid, raid_date: Date.parse("01/07/2012"), raid_type: progression)
    @inst1 = FactoryGirl.create(:instance, raid_id: raid.id, start_time: DateTime.parse("01/07/2012 18:00"))
    @inst2 = FactoryGirl.create(:instance, raid_id: raid.id, start_time: DateTime.parse("01/07/2012 20:00"))
  end

  describe 'GET index' do
    it 'assigns all character_instances as @character_instances' do
      character_instance = FactoryGirl.create(:character_instance, character_id: @char1.id, instance_id: @inst1.id)
      get :index
      assigns(:character_instances).should eq([character_instance])
    end

    it 'renders xml' do
      character_instance = FactoryGirl.create(:character_instance)

      get :index, format: :xml

      response.content_type.should eq('application/xml')
      response.body.should have_selector('character-instances', type: 'array') do |results|
        results.should have_selector('character-instance') do |pr|
          pr.should have_selector('character-id', type: 'integer', content: character_instance.character_id.to_s)
          pr.should have_selector('instance-id', type: 'integer', content: character_instance.instance_id.to_s)
        end
      end
      response.body.should eq([character_instance].to_xml)
    end

    it 'renders json' do
      character_instance = FactoryGirl.create(:character_instance)

      get :index, format: :json

      response.content_type.should eq('application/json')
      JSON.parse(response.body).should include(character_instance.as_json)
    end

    it 'should filter by instance when getting json' do
      ci1 = FactoryGirl.create(:character_instance, character_id: @char1.id, instance_id: @inst1.id)
      FactoryGirl.create(:character_instance, character_id: @char2.id, instance_id: @inst2.id)

      get :index, format: :json, instance_id: @inst1.id

      parsed_result = JSON.parse(response.body)
      parsed_result.count.should eq 1
      parsed_result.first['character_instance']['id'].should eq ci1.id
      parsed_result.first['character_instance']['character_id'].should eq @char1.id
      parsed_result.first['character_instance']['instance_id'].should eq @inst1.id
    end

    it 'should filter by character when getting json' do
      FactoryGirl.create(:character_instance, character_id: @char1.id, instance_id: @inst1.id)
      ci2 = FactoryGirl.create(:character_instance, character_id: @char2.id, instance_id: @inst2.id)

      get :index, format: :json, character_id: @char2.id

      parsed_result = JSON.parse(response.body)
      parsed_result.count.should eq 1
      parsed_result[0]['character_instance']['id'].should eq ci2.id
      parsed_result[0]['character_instance']['character_id'].should eq @char2.id
      parsed_result[0]['character_instance']['instance_id'].should eq @inst2.id
    end
  end

  describe 'GET show' do
    it 'assigns the requested character_instance as @character_instance' do
      character_instance = FactoryGirl.create(:character_instance, character_id: @char1.id, instance_id: @inst1.id)
      get :show, format: :json, id: character_instance.id.to_s
      assigns(:character_instance).should eq(character_instance)
    end

    it 'renders xml' do
      character_instance = FactoryGirl.create(:character_instance)

      get :show, format: :xml, id: character_instance.id

      response.content_type.should eq('application/xml')
      response.body.should eq(character_instance.to_xml)
    end

    it 'renders json' do
      character_instance = FactoryGirl.create(:character_instance)

      get :show, format: :json, id: character_instance

      response.content_type.should eq('application/json')
      JSON.parse(response.body).should eq(character_instance.as_json)
    end
  end

  describe 'GET new' do
    it 'assigns a new character_instance as @character_instance' do
      get :new
      assigns(:character_instance).should be_a_new(CharacterInstance)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new CharacterInstance' do
        expect {
          post :create, {character_instance: FactoryGirl.build(:character_instance).attributes.symbolize_keys}
        }.to change(CharacterInstance, :count).by(1)
      end

      it 'assigns a newly created character_instance as @character_instance' do
        post :create, {character_instance: FactoryGirl.build(:character_instance).attributes.symbolize_keys}
        assigns(:character_instance).should be_a(CharacterInstance)
        assigns(:character_instance).should be_persisted
      end

      it 'redirects to the created character_instance' do
        post :create, format: :json, character_instance: FactoryGirl.build(:character_instance).attributes.symbolize_keys
        response.status.should == 201 # created
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved character_instance as @character_instance' do
        CharacterInstance.any_instance.stub(:save).and_return(false)
        post :create, {character_instance: {}}
        assigns(:character_instance).should be_a_new(CharacterInstance)
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested character_instance' do
        character_instance = CharacterInstance.create! FactoryGirl.build(:character_instance).attributes.symbolize_keys
        CharacterInstance.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {id: character_instance.to_param, character_instance: {'these' => 'params'}}
      end

      it 'assigns the requested character_instance as @character_instance' do
        character_instance = CharacterInstance.create! FactoryGirl.build(:character_instance).attributes.symbolize_keys
        put :update, {id: character_instance.to_param, character_instance: FactoryGirl.build(:character_instance).attributes.symbolize_keys}
        assigns(:character_instance).should eq(character_instance)
      end

      it 'responds with 200' do
        character_instance = CharacterInstance.create! FactoryGirl.build(:character_instance).attributes.symbolize_keys
        put :update, format: :json, id: character_instance.to_param, character_instance: FactoryGirl.build(:character_instance).attributes.symbolize_keys
        response.status.should == 200 # OK
      end
    end

    describe 'with invalid params' do
      it 'assigns the character_instance as @character_instance' do
        character_instance = CharacterInstance.create! FactoryGirl.build(:character_instance).attributes.symbolize_keys
        CharacterInstance.any_instance.stub(:save).and_return(false)
        put :update, {id: character_instance.to_param, character_instance: {}}
        assigns(:character_instance).should eq(character_instance)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested character_instance' do
      character_instance = CharacterInstance.create! FactoryGirl.build(:character_instance).attributes.symbolize_keys
      expect {
        delete :destroy, {id: character_instance.to_param}
      }.to change(CharacterInstance, :count).by(-1)
    end
  end
end