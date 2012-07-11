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

  it "filters by player" do
    Character.create! valid_attributes
    jenny_player = FactoryGirl.create(:player, :name => "Jenny", :rank => @main_rank)
    jenny = Character.create! valid_attributes.merge!({:name => "Jenny", :player_id => jenny_player.id})

    get :index, :player_id => jenny.player_id
    assigns(:characters).should eq([jenny])
  end

  it "filters by name" do
    Character.create! valid_attributes
    jenny = Character.create! valid_attributes.merge! :name => "Jenny"

    get :index, :name => "Jenny"
    assigns(:characters).should eq([jenny])
  end

  it "filters by instance" do
    jimmy = Character.create! valid_attributes
    jenny = Character.create! valid_attributes.merge! :name => "Jenny"
    raid_date = Date.new(2012, 12, 25)
    raid = FactoryGirl.create(:raid, :raid_date => raid_date)
    first_instance = FactoryGirl.create(:instance, :raid_id => raid.id, :start_time => raid_date + 20.hours)
    second_instance = FactoryGirl.create(:instance, :raid_id => raid.id, :start_time => raid_date + 21.hours)
    FactoryGirl.create(:character_instance, :instance_id => first_instance.id, :character_id => jimmy.id)
    FactoryGirl.create(:character_instance, :instance_id => first_instance.id, :character_id => jenny.id)
    FactoryGirl.create(:character_instance, :instance_id => second_instance.id, :character_id => jimmy.id)

    get :index, :instance_id => second_instance.id
    assigns(:characters).should eq([jimmy])
  end

  it "returns CSV" do
    jimmy = Character.create! valid_attributes
    jenny = Character.create! valid_attributes.merge! :name => "Jenny"

    get :index, :format => :csv

    assigns(:characters).should include jimmy
    assigns(:characters).should include jenny

    response.content_type.should eq('text/csv')
    response.header.should eq('Content-Type' => 'text/csv; charset=utf-8')
  end
end