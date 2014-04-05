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
    raid = FactoryGirl.create(:raid, raid_date: Date.parse('01/07/2012'),
                              raid_type: progression)
    @inst1 = FactoryGirl.create(:instance, raid_id: raid.id,
                                start_time: DateTime.parse('01/07/2012 18:00'))
    @inst2 = FactoryGirl.create(:instance, raid_id: raid.id,
                                start_time: DateTime.parse('01/07/2012 20:00'))
  end

  describe 'GET index' do
    it 'assigns all character_instances as @character_instances' do
      character_instance =
          FactoryGirl.create(:character_instance,
                             character_id: @char1.id,
                             instance_id: @inst1.id)
      get :index, format: :json
      expect(assigns(:character_instances)).to eq [character_instance]
    end

    it 'renders xml' do
      ci = FactoryGirl.create(:character_instance)

      get :index, format: :xml

      expect(response.content_type).to eq 'application/xml'
      expect(response.body).to have_selector('character-instances', type: 'array') do |results|
        expect(results).to have_selector('character-instance') do |pr|
          expect(pr).to have_selector('character-id', type: 'integer', content: ci.character_id.to_s)
          expect(pr).to have_selector('instance-id', type: 'integer', content: ci.instance_id.to_s)
        end
      end
      expect(response.body).to eq [ci].to_xml
    end

    it 'renders json' do
      character_instance = FactoryGirl.create(:character_instance)

      get :index, format: :json

      expect(response.content_type).to eq 'application/json'
      expect(JSON.parse(response.body)).to include character_instance.as_json
    end

    it 'filters by instance when getting json' do
      ci1 = FactoryGirl.create(:character_instance,
                               character_id: @char1.id,
                               instance_id: @inst1.id)
      FactoryGirl.create(:character_instance,
                         character_id: @char2.id,
                         instance_id: @inst2.id)

      get :index, format: :json, instance_id: @inst1.id

      parsed_result = JSON.parse(response.body)

      expect(parsed_result.count).to eq 1
      expect(parsed_result.first['character_instance']['id']).to eq ci1.id
      expect(parsed_result.first['character_instance']['character_id']).to eq @char1.id
      expect(parsed_result.first['character_instance']['instance_id']).to eq @inst1.id
    end

    it 'filters by character when getting json' do
      FactoryGirl.create(:character_instance, character_id: @char1.id,
                         instance_id: @inst1.id)
      ci2 = FactoryGirl.create(:character_instance, character_id: @char2.id,
                               instance_id: @inst2.id)

      get :index, format: :json, character_id: @char2.id

      parsed_result = JSON.parse(response.body)

      expect(parsed_result.count).to eq 1
      expect(parsed_result[0]['character_instance']['id']).to eq ci2.id
      expect(parsed_result[0]['character_instance']['character_id']).to eq @char2.id
      expect(parsed_result[0]['character_instance']['instance_id']).to eq @inst2.id
    end
  end

  describe 'GET show' do
    it 'assigns the requested character_instance as @character_instance' do
      character_instance = FactoryGirl.create(:character_instance,
                                              character_id: @char1.id,
                                              instance_id: @inst1.id)
      get :show, format: :json, id: character_instance.id.to_s
      expect(assigns(:character_instance)).to eq character_instance
    end

    it 'renders xml' do
      character_instance = FactoryGirl.create(:character_instance)

      get :show, format: :xml, id: character_instance.id

      expect(response.content_type).to eq  'application/xml'
      expect(response.body).to eq character_instance.to_xml
    end

    it 'renders json' do
      character_instance = FactoryGirl.create(:character_instance)

      get :show, format: :json, id: character_instance

      expect(response.content_type).to eq 'application/json'
      expect(JSON.parse(response.body)).to eq character_instance.as_json
    end
  end

  describe 'GET new' do
    it 'renders the new template' do
      get :new, format: :json
      expect(response).to render_template :new
    end

    it 'assigns a new character_instance as @character_instance' do
      get :new, format: :xml
      expect(assigns(:character_instance)).to be_a_new CharacterInstance
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new CharacterInstance' do
        expect {
          post :create, {
              character_instance: FactoryGirl.build(:character_instance).
                  attributes.symbolize_keys
          }
        }.to change(CharacterInstance, :count).by 1
      end

      it 'assigns a newly created character_instance as @character_instance' do
        post :create, {
            character_instance: FactoryGirl.build(:character_instance).
                attributes.symbolize_keys
        }
        expect(assigns(:character_instance)).to be_a CharacterInstance
        expect(assigns(:character_instance)).to be_persisted
      end

      context 'redirects to the created character_instance' do
        example 'with an XML response' do
          post :create, format: :xml,
               character_instance: FactoryGirl.attributes_for(:character_instance)
          expect(response.status).to eq 201 # Created
        end

        example 'with a JSON response' do
          post :create, format: :json,
               character_instance: FactoryGirl.attributes_for(:character_instance)
          expect(response.status).to eq 201 # Created
        end
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created character_instance as @character_instance' do
        CharacterInstance.any_instance.stub(:save).and_return(false)
        post :create, {character_instance: {}, format: :xml}
        expect(assigns(:character_instance)).to be_a_new CharacterInstance
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested character_instance' do
        character_instance =
            CharacterInstance.create! FactoryGirl.attributes_for(:character_instance)
        CharacterInstance.any_instance.should_receive(:update_attributes).
            with({'these' => 'params'})
        put :update, {id: character_instance.to_param,
                      character_instance: {'these' => 'params'}, format: :xml}
      end

      it 'assigns the requested character_instance as @character_instance' do
        character_instance =
            CharacterInstance.create! FactoryGirl.attributes_for(:character_instance)
        put :update, {
            id: character_instance.to_param,
            character_instance: FactoryGirl.build(:character_instance).
                attributes.symbolize_keys, format: :json}
        expect(assigns(:character_instance)).to eq character_instance
      end

      it 'responds with 200' do
        character_instance =
            CharacterInstance.create! FactoryGirl.build(:character_instance).
                                          attributes.symbolize_keys
        put :update, format: :json, id: character_instance.to_param,
            character_instance: FactoryGirl.attributes_for(:character_instance)
        expect(response.status).to eq 200 # OK
      end
    end

    describe 'with invalid params' do
      it 'assigns the character_instance as @character_instance' do
        character_instance =
            CharacterInstance.create! FactoryGirl.build(:character_instance).
                                          attributes.symbolize_keys
        CharacterInstance.any_instance.stub(:save).and_return(false)
        put :update, id: character_instance.to_param, character_instance: {}, format: :xml
        expect(assigns(:character_instance)).to eq character_instance
      end

      it 'responds with an error code' do
        character_instance =
            CharacterInstance.create! FactoryGirl.build(:character_instance).
                                          attributes.symbolize_keys
        CharacterInstance.any_instance.stub(:save).and_return(false)
        put :update, id: character_instance.to_param, character_instance: {}, format: :json
        expect(response.status).to eq 422 # Unprecessable Entity
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested character_instance' do
      character_instance =
          CharacterInstance.create! FactoryGirl.build(:character_instance).
                                        attributes.symbolize_keys
      expect {
        delete :destroy, {id: character_instance.to_param}
      }.to change(CharacterInstance, :count).by(-1)
    end
  end
end
