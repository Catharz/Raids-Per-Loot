require 'spec_helper'

describe "players/statistics.html.haml" do
  fixtures :users

  before(:each) do
    main_rank = stub_model(Rank, :name => 'Main')
    scout = stub_model(Archetype, :name => 'Scout')
    fighter = stub_model(Archetype, :name => 'Fighter')
    priest = stub_model(Archetype, :name => 'Priest')
    mage = stub_model(Archetype, :name => 'Mage')

    scout_player = stub_model(Player, :name => 'Scout Main', :rank_id => main_rank.id)
    fighter_player = stub_model(Player, :name => 'Fighter Main', :rank_id => main_rank.id)
    priest_player = stub_model(Player, :name => 'Priest Alternate', :rank_id => main_rank.id)
    mage_player = stub_model(Player, :name => 'Mage Alternate', :rank_id => main_rank.id)

    assign(:players, [scout_player, fighter_player, priest_player, mage_player])
    assign(:archetypes, [fighter, priest, mage, scout])
    assign(:ranks, [main_rank])
  end

  it 'shows tabs for raid mains and raid alts' do
    render

    assert_select 'div#raid_mains', :count => 1
    assert_select 'div#raid_alts', :count => 1
  end

  it 'should list main character names' do
    render

    assert_select 'tr>td', :text => 'Scout Main'.to_s, :count => 1
    assert_select 'tr>td', :text => 'Fighter Main'.to_s, :count => 1
  end
end