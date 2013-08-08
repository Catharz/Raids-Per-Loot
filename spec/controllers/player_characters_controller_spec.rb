require 'spec_helper'
require 'authentication_spec_helper'

describe PlayerCharactersController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  describe 'GET edit' do
    it 'assigns the requested player character as @player_character' do
      player = FactoryGirl.create(:player)
      character = FactoryGirl.create(:character, player_id: player.id)

      get :edit, :id => character.id, format: :js

      assigns(:player_character).character.should eq(character)
      assigns(:player_character).player.should eq(player)
    end
  end

  describe 'PUT update' do
    before(:each) do
      @player = FactoryGirl.create(:player)
      @character = FactoryGirl.create(:character, player_id: @player.id)
      @player_character = PlayerCharacter.new(@character.id)
    end

    it 'assigns the updated player character to @player_character' do
      put :update, :id => @player_character.id, player_character: @player_character.attributes

      @character.reload
      @player.reload
      @player_character.reload
      assigns(:player_character).character.should eq(@character)
      assigns(:player_character).player.should eq(@player)
      assigns(:player_character).should eq(@player_character)
    end

    context 'when successful' do
      it 'changes the characters attributes' do
        put :update, id: @player_character.id, player_character: @player_character.attributes.merge!({mounts_count: 10})

        @character.reload
        @character.mounts_count.should eq 10
      end

      it 'changes the players attributes' do
        put :update, id: @player_character.id.to_s, player_character: @player_character.attributes.merge!({raids_count: 10})

        @player.reload
        @player.raids_count.should eq 10
      end

      it 're-renders the updated player character' do
        put :update, id: @player_character.id.to_s, player_character: @player_character.attributes.merge!({armour_count: 10})

        response.should render_template @player_character
      end

      it 'renders the player and character' do
        method_list = [:player, :character, :main_character]

        method_list.each_with_index do |method, index|
          put :update, id: @player_character.id.to_s,
              player_character: @player_character.attributes.merge!({mount_count: index}), format: :json

          result = JSON.parse(response.body).with_indifferent_access
          result[method].should_not be_nil
        end
      end
    end

    context 'when unsuccessful' do
      it 're-renders the player character' do
        put :update, id: @player_character.id.to_s, player_character: @player_character.attributes.merge!({confirmed_rating: 'optimal'})

        response.should render_template @player_character
      end

      it 'sets appropriate error messages' do
        put :update, id: @player_character.id.to_s, player_character: @player_character.attributes.merge!({confirmed_rating: 'optimal'})

        assigns(:player_character).errors.messages[:base].should include 'Must have a rating and a date'
      end
    end
  end
end