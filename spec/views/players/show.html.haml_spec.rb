require 'spec_helper'
require 'date'
require 'authentication_spec_helper'

describe 'players/show.html.haml' do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin

    @player = assign(:player, stub_model(Player, name: 'Name'))

    armour = stub_model(LootType, name: 'Armour', default_loot_method: 'n')
    armour_item = stub_model(Item, name: 'Phat BP', :eq2_item_id => '1234',
                             loot_type_id: armour.id)
    armour_item.stub(:loot_type).and_return(armour)

    weapon = stub_model(LootType, name: 'Weapon', default_loot_method: 'n')
    weapon_item = stub_model(Item, name: 'Phat Sword', :eq2_item_id => '1235',
                             loot_type_id: weapon.id)
    weapon_item.stub(:loot_type).and_return(weapon)

    armour_drop = stub_model(Drop,
                             zone_name: 'Wherever',
                             mob_name: 'Mob Name',
                             player_name: 'Player Name',
                             item_name: 'Phat BP',
                             :eq2_item_id => '1234',
                             loot_type: armour)
    armour_drop.stub(:item).and_return(armour_item)
    weapon_drop = stub_model(Drop,
                             zone_name: 'Wherever Next',
                             mob_name: 'Mob Name',
                             player_name: 'Player Name',
                             item_name: 'Phat Sword',
                             :eq2_item_id => '1235',
                             loot_type: weapon)
    weapon_drop.stub(:item).and_return(weapon_item)

    @player.stub(:characters).and_return([])
    @player.stub(:raids_count).and_return(1)
    @player.stub(:instances_count).and_return(2)
    @player.stub(:drops).and_return([armour_drop, weapon_drop])
    @player.stub(:armour_rate).and_return(2.0)
    @player.stub(:weapon_rate).and_return(3.6)
    @player.stub(:jewellery_rate).and_return(6.9)
  end

  it 'should list the separate sections' do
    render

    rendered.should match(/Details/)
    rendered.should match(/Characters/)
    rendered.should match(/Drops/)
    rendered.should match(/Attendance/)
  end

  it 'should show the loot types' do
    render

    rendered.should match(/Weapon/)
    rendered.should match(/Armour/)
  end

  it 'should list the loot items' do
    render

    rendered.should match(/Phat Sword/)
    rendered.should match(/Phat BP/)
  end

  it 'should show the number of characters' do
    render

    rendered.should contain('Characters: 0')
  end

  it 'should show the number of raids' do
    render

    rendered.should contain('Raids: 1')
  end

  it 'should show the number of instances' do
    render

    rendered.should contain('Instances: 2')
  end

  it 'should show the number of drops' do
    render

    rendered.should contain('Drops: 2')
  end

  it 'should show the armour rate' do
    render

    rendered.should contain('Armour Rate: 2.0')
  end

  it 'should show the weapon rate' do
    render

    rendered.should contain('Weapon Rate: 3.6')
  end

  it 'should show the jewellery rate' do
    render

    rendered.should contain('Jewellery Rate: 6.9')
  end
end
