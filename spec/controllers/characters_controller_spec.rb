require 'spec_helper'
require 'character_spec_helper'

describe CharactersController do
  include CharacterSpecHelper
  fixtures :users

  before(:each) do
    login_as :quentin

    @main_rank ||= FactoryGirl.create(:rank, :name => "Main")
    @player ||= FactoryGirl.create(:player, :name => "Jimmy", :rank => @main_rank)
    @archetype ||= FactoryGirl.create(:archetype, :name => "Scout")
  end

  def valid_attributes
    {:name => "Jimmy", :player_id => @player.id, :archetype_id => @archetype.id, :char_type => "m"}
  end

  it "assigns all characters as @characters" do
    character = Character.create! valid_attributes
    get :index
    assigns(:characters).should eq([character])
  end
end