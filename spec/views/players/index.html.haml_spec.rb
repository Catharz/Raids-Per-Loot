require 'spec_helper'
require 'will_paginate/array'

describe "players/index.html.erb" do
  fixtures :users

  before(:each) do
    login_as users(:quentin)

    scout = stub_model(Archetype, :name => "Scout")
    fighter = stub_model(Archetype, :name => "Fighter")
    priest = stub_model(Archetype, :name => "Priest")
    mage = stub_model(Archetype, :name => "Mage")

    scout_player = stub_model(Player,
                              :name => "Scout Main",
                              :archetype_id => scout.id)
    fighter_player = stub_model(Player,
                                :name => "Fighter Main",
                                :archetype_id => fighter.id)
    priest_player = stub_model(Player,
                               :name => "Priest Alternate",
                               :archetype_id => priest.id,
                               :main_character_id => fighter_player.id)
    mage_player = stub_model(Player,
                             :name => "Mage Alternate",
                             :archetype_id => mage.id,
                             :main_character_id => scout_player.id)

    assign(:players, [scout_player, fighter_player, priest_player, mage_player].paginate(:per_page => 20, :page => 1))
    assign(:archetypes, [fighter, priest, mage, scout])

    PlayersHelper.class_exec { def sort_column() "name" end }
    PlayersHelper.class_exec { def sort_direction() "asc" end }
  end

  it "should list main character names for mains and alternates" do
    render

    assert_select "tr>td", :text => "Scout Main".to_s, :count => 2
    assert_select "tr>td", :text => "Fighter Main".to_s, :count => 2
  end

  it "should list alternate names once" do
    render

    assert_select "tr>td", :text => "Priest Alternate".to_s, :count => 2
    assert_select "tr>td", :text => "Mage Alternate".to_s, :count => 2
  end
end
