require 'spec_helper'

describe 'players/statistics.html.haml' do
  fixtures :users

  before(:each) do
    scout = stub_model(Archetype, :name => 'Scout')
    fighter = stub_model(Archetype, :name => 'Fighter')
    priest = stub_model(Archetype, :name => 'Priest')
    mage = stub_model(Archetype, :name => 'Mage')

    player1 = stub_model(Player, name: 'Player One', main_name: 'Scout Main')
    scout_character = stub_model(Character,
                                 name: 'Scout Main',
                                 archetype_name: 'Scout',
                                 armour_rate: 1.23,
                                 weapon_rate: 2.34,
                                 jewellery_rate: 3.45,
                                 archetype: scout,
                                 player: player1)
    priest_character = stub_model(Character,
                                  name: 'Priest Alternate',
                                  archetype_name: 'Priest',
                                  armour_rate: 3.21,
                                  weapon_rate: 4.32,
                                  jewellery_rate: 5.43,
                                  archetype: priest,
                                  player: player1)
    player1.should_receive(:current_main).twice.and_return(scout_character)
    player1.should_receive(:current_raid_alternate).twice.and_return(priest_character)

    player2 = stub_model(Player, name: 'Player One', main_name: 'Fighter Main')
    fighter_character = stub_model(Character,
                                   name: 'Fighter Main',
                                   archetype_name: 'Fighter',
                                   armour_rate: 4.56,
                                   weapon_rate: 5.67,
                                   jewellery_rate: 6.78,
                                   archetype: fighter,
                                   player: player2)
    mage_character = stub_model(Character,
                                name: 'Mage Alternate',
                                archetype_name: 'Mage',
                                armour_rate: 6.54,
                                weapon_rate: 7.65,
                                jewellery_rate: 8.76,
                                archetype: mage,
                                player: player2)
    player2.should_receive(:current_main).twice.and_return(fighter_character)
    player2.should_receive(:current_raid_alternate).twice.and_return(mage_character)

    assign(:players, [player1, player2])
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