require 'spec_helper'
require 'authentication_spec_helper'

describe CharactersController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  describe 'GET #option_list' do
    it 'should populate an option list with sorted character names' do
      character1 = FactoryGirl.create(:character)
      character2 = FactoryGirl.create(:character)
      get :option_list
      response.body.
          should eq("<option value='#{character1.id}'>" +
                        "#{character1.name}</option>" +
                        "<option value='#{character2.id}'>" +
                        "#{character2.name}</option>")
    end
  end

  describe 'GET #attendance' do
    it 'should populate a list of characters' do
      character1 = FactoryGirl.create(:character)
      character2 = FactoryGirl.create(:character)
      character1.should_receive(:attendance).twice.times.and_return(90.0)
      character2.should_receive(:attendance).twice.times.and_return(80.0)
      characters = [character1, character2]
      Character.should_receive(:order).with(:name).and_return(characters)

      get :attendance

      assigns(:characters).should match_array [character1, character2]
    end

    it 'responds with JSON' do
      character1 = FactoryGirl.create(:character)
      character2 = FactoryGirl.create(:character)
      character1.stub(:attendance).and_return(100.0)
      character2.stub(:attendance).and_return(100.0)
      characters = [character1, character2]
      Character.should_receive(:order).with(:name).and_return(characters)

      get :attendance, format: :json

      result = JSON.parse(response.body)
      result.should eq [JSON.parse(character1.to_json(
                                       methods: [:player_name,
                                                 :archetype_name,
                                                 :archetype_root_name,
                                                 :attendance])),
                        JSON.parse(character2.to_json(
                                       methods: [:player_name,
                                                 :archetype_name,
                                                 :archetype_root_name,
                                                 :attendance]))]
    end

    it 'responds with XML' do
      character1 = FactoryGirl.create(:character)
      character2 = FactoryGirl.create(:character)
      character1.stub(:attendance).and_return(100.0)
      character2.stub(:attendance).and_return(100.0)
      characters = [character1, character2]
      Character.should_receive(:order).with(:name).and_return(characters)

      get :attendance, format: :xml

      response.body.should eq characters.to_xml(only: [:id, :name], methods: [:attendance])
    end

    it 'only returns characters with more than 10% attendance' do
      character1 = FactoryGirl.create(:character)
      character2 = FactoryGirl.create(:character)
      character1.stub(:attendance).and_return(7.06)
      character2.stub(:attendance).and_return(10.9)
      characters = [character1, character2]
      Character.should_receive(:order).with(:name).and_return(characters)

      get :attendance, format: :json

      result = JSON.parse(response.body)
      result.should eq [JSON.parse(character2.to_json(
                                       methods: [:player_name,
                                                 :archetype_name,
                                                 :archetype_root_name,
                                                 :attendance]))]
    end

    it 'lists characters with higher attendance first' do
      character1 = FactoryGirl.create(:character)
      character2 = FactoryGirl.create(:character)
      character1.should_receive(:attendance).at_least(3).times.and_return(90.0)
      character2.should_receive(:attendance).at_least(3).times.and_return(100.0)
      characters = [character1, character2]
      Character.should_receive(:order).with(:name).and_return(characters)

      get :attendance, format: :json

      result = JSON.parse(response.body)
      result.should eq [JSON.parse(character2.to_json(
                                       methods: [:player_name,
                                                 :archetype_name,
                                                 :archetype_root_name,
                                                 :attendance])),
                        JSON.parse(character1.to_json(
                                       methods: [:player_name,
                                                 :archetype_name,
                                                 :archetype_root_name,
                                                 :attendance]))]
    end
  end

  describe 'POST #fetch_data' do
    it 'assigns the requested character to @character' do
      character = FactoryGirl.create(:character)
      post :fetch_data, id: character
      assigns(:character).should eq(character)
    end

    it 'calls SonyDataService.fetch_soe_character_details for the character' do
      character = FactoryGirl.create(:character)
      Resque.should_receive(:enqueue).with(SonyCharacterUpdater, character.id)

      post :fetch_data, id: character
    end

    it 'redirects to the updated @character' do
      character = FactoryGirl.create(:character)
      Resque.should_receive(:enqueue).with(SonyCharacterUpdater, character.id)
      post :fetch_data, id: character
      response.should redirect_to character
    end
  end

  describe 'GET #statistics' do
    it 'populates a collection of characters' do
      character = FactoryGirl.create(:character)
      get :statistics
      assigns(:characters).should eq([character])
    end

    it 'renders the statistics view' do
      get :statistics
      response.should render_template :statistics
    end
  end

  describe 'GET #loot' do
    it 'sorts the characters by name' do
      active_player = FactoryGirl.create(:player, active: true)
      inactive_player = FactoryGirl.create(:player, active: false)
      character1 = FactoryGirl.create(:character,
                                      name: 'Character C',
                                      player: active_player)
      character2 = FactoryGirl.create(:character,
                                      name: 'Character B',
                                      player: inactive_player)
      character3 = FactoryGirl.create(:character,
                                      name: 'Character A',
                                      player: active_player)

      get :loot

      assigns(:characters).should eq([character3, character2, character1])
    end

    it 'renders the loot template' do
      get :loot

      response.should have_rendered :loot
    end
  end

  describe 'GET #index' do
    it 'populates a collection of characters' do
      character = FactoryGirl.create(:character)
      get :index
      assigns(:characters).should eq([character])
    end

    it 'renders the :index view' do
      get :index
      response.should render_template :index
    end

    it 'filters by player' do
      character = FactoryGirl.create(:character)
      FactoryGirl.create(:character)

      get :index, player_id: character.player_id
      assigns(:characters).should eq([character])
    end

    it 'filters by name' do
      FactoryGirl.create(:character)
      jenny = FactoryGirl.create(:character, name: 'Jenny')

      get :index, name: 'Jenny'
      assigns(:characters).should eq([jenny])
    end

    it 'filters by instance' do
      jimmy = FactoryGirl.create(:character, name: 'Jimmy')
      jenny = FactoryGirl.create(:character, name: 'Jenny')
      first_instance = FactoryGirl.create(:instance)
      second_instance = FactoryGirl.create(:instance)
      FactoryGirl.create(:character_instance,
                         instance: first_instance,
                         character: jimmy)
      FactoryGirl.create(:character_instance,
                         instance: first_instance,
                         character: jenny)
      FactoryGirl.create(:character_instance,
                         instance: second_instance,
                         character: jimmy)

      get :index, instance_id: second_instance.id
      assigns(:characters).should eq([jimmy])
    end

    it 'filters by player' do
      jack = FactoryGirl.create(:character, name: 'Jack',
                                player: FactoryGirl.create(:player,
                                                           name: 'Jack'))
      jill = FactoryGirl.create(:character, name: 'Jill',
                                player: FactoryGirl.create(:player,
                                                           name: 'Jill'))

      get :index, player_id: jack.player_id
      assigns(:characters).should eq([jack])
    end

    it 'can render CSV' do
      jimmy = FactoryGirl.create(:character, name: 'Jimmy')
      jenny = FactoryGirl.create(:character, name: 'Jenny')

      get :index, format: :csv

      assigns(:characters).should include jimmy
      assigns(:characters).should include jenny

      response.content_type.should eq('text/csv')
      response.header.should eq('Content-Type' => 'text/csv; charset=utf-8')
    end
  end

  describe 'GET #show' do
    it 'assigns the requested character to @character' do
      character = FactoryGirl.create(:character)
      get :show, id: character
      assigns(:character).should eq(character)
    end

    it 'renders the :show template' do
      get :show, id: FactoryGirl.create(:character)
      response.should render_template :show
    end

    it 'responds with JSON' do
      character = FactoryGirl.create(:character)
      get :show, id: character, format: :json
      response.body.should eq character.to_json(methods: [:player_name, :player_raids_count, :player_active,
                                                          :player_switches_count, :player_switch_rate])
    end

    it 'responds with XML' do
      character = FactoryGirl.create(:character)
      get :show, id: character, format: :xml
      response.body.should eq character.to_xml(methods: [:instances, :drops])
    end
  end

  describe 'GET #info' do
    it 'assigns the requested character to @character' do
      character = FactoryGirl.create(:character)
      get :info, id: character
      assigns(:character).should eq(character)
    end

    it 'renders the :info template without the layout' do
      get :info, id: FactoryGirl.create(:character)
      response.should render_template :info, layout: false
    end
  end

  describe 'GET #new' do
    it 'assigns a new character to @character' do
      character = Character.new
      Character.should_receive(:new).and_return(character)
      get :new
      assigns(:character).should eq(character)
    end

    it 'renders the :new template' do
      get :new
      response.should render_template :new
    end

    it 'responds to JSON' do
      get :new, format: :json
      response.body.should eq Character.new.to_json(methods: :player_name)
    end

    it 'responds to XML' do
      get :new, format: :xml
      response.body.should eq Character.new.to_xml(methods: :player_name)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested character as @character' do
      character = Character.create! FactoryGirl.attributes_for(:character)
      get :edit, id: character.id.to_s
      assigns(:character).should eq(character)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new character' do
        expect {
          post :create, character: FactoryGirl.attributes_for(:character)
        }.to change(Character, :count).by(1)
      end

      it 'redirects to the new character' do
        post :create, character: FactoryGirl.attributes_for(:character)
        response.should redirect_to Character.last
      end

      it 'responds to JSON' do
        post :create,
             character: FactoryGirl.attributes_for(:character), format: 'json'
        response.response_code.should eq 201
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new character' do
        expect {
          post :create,
               character: FactoryGirl.attributes_for(:invalid_character)
        }.to_not change(Character, :count)
      end

      it 're-renders the :new template' do
        post :create,
             character: FactoryGirl.attributes_for(:invalid_character)
        response.should render_template :new
      end
    end
  end

  describe 'POST #update_data' do
    before(:each) do
      request.env['HTTP_REFERER'] = 'previous_page'
    end

    it 'uses the SonyCharacterUpdater' do
      char1 = FactoryGirl.create(:character)
      SonyCharacterUpdater.should_receive(:perform).with(char1.id.to_s)

      post :update_data, id: char1.id
    end

    it 'redirects to the previous page' do
      char1 = FactoryGirl.create(:character)
      SonyCharacterUpdater.should_receive(:perform).with(char1.id.to_s)

      post :update_data, id: char1.id
      response.should redirect_to 'previous_page'
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @player = FactoryGirl.create(:player, name: 'Fred')
      @archetype = FactoryGirl.create(:archetype)
      @character = FactoryGirl.create(:character,
                                      name: 'Fred',
                                      char_type: 'm',
                                      player: @player,
                                      archetype: @archetype)
    end

    context 'valid attributes' do
      it 'located the requested @character' do
        put :update, id: @character,
            character: FactoryGirl.attributes_for(:character)
        assigns(:character).should eq (@character)
      end

      it "changes @character's attributes" do
        put :update, id: @character,
            character: @character.attributes.merge!({name: 'Barney',
                                                     char_type: 'r'})
        @character.reload
        @character.name.should eq('Barney')
        @character.char_type.should eq('r')
      end

      it 'redirects to the updated @character' do
        put :update, id: @character, character: @character.attributes
        response.should redirect_to @character
      end

      context 'JSON response' do
        it 'responds to JSON' do
          put :update, id: @character, character:
              @character.attributes.merge!({name: 'Bam Bam',
                                            char_type: 'r'}), format: 'json'

          response.response_code.should == 200
        end

        context 'extra methods' do
          it 'returns all the normal methods' do
            method_list = [:archetype_name, :archetype_root, :player_name,
                           :first_raid_date, :last_raid_date, :armour_rate,
                           :jewellery_rate, :weapon_rate]
            method_list.each_with_index do |method, index|
              put :update, id: @character,
                  character: @character.attributes.
                      merge!({name: "Update #{index}"}), format: 'json'

              result = JSON.parse(response.body).with_indifferent_access
              result[:character][method].should eq @character.send(method)
            end
          end

          it 'returns the main character' do
            put :update, id: @character, character:
                @character.attributes.merge!({name: 'Bam Bam',
                                              char_type: 'r'}), format: 'json'

            result = JSON.parse(response.body).with_indifferent_access
            result[:character][:main_character].
                should eq JSON.parse(@character.main_character.to_json)
          end
        end
      end
    end

    context 'invalid attributes' do
      it 'locates the requested @character' do
        put :update, id: @character,
            character: FactoryGirl.attributes_for(:invalid_character)
        assigns(:character).should eq (@character)
      end

      it "does not change @character's attributes" do
        put :update, id: @character,
            character: FactoryGirl.attributes_for(:character,
                                                  name: 'Whatever',
                                                  char_type: nil)
        @character.reload
        @character.name.should_not eq('Whatever')
        @character.char_type.should eq('m')
      end

      it 're-renders the :edit template' do
        put :update, id: @character,
            character: FactoryGirl.attributes_for(:invalid_character)
        response.should render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @character = FactoryGirl.create(:character)
    end

    it 'deletes the character' do
      expect {
        delete :destroy, id: @character
      }.to change(Character, :count).by(-1)
    end

    it 'redirects to characters#index' do
      delete :destroy, id: @character
      response.should redirect_to characters_url
    end
  end
end