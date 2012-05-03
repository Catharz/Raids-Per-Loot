require 'spec_helper'
require 'date'

describe "players/show.html.erb" do
  fixtures :users

  before(:each) do
    login_as users(:quentin)

    @player = assign(:player, stub_model(Player, :name => "Name"))

    zone_1 = stub_model(Zone, :name => "Wherever")
    zone_2 = stub_model(Zone, :name => "Wherever Next")
    instance_1 = stub_model(Instance, :start_time => DateTime.parse("01/01/2011 18:00"), :end_time => DateTime.parse("01/01/2011 20:00"))
    instance_1.zone = zone_1
    instance_2 = stub_model(Instance, :start_time => DateTime.parse("01/01/2011 20:05"), :end_time => DateTime.parse("01/01/2011 22:00"))
    instance_2.zone = zone_2

    @player.stub!(:instances).and_return([instance_1, instance_2])

    armour = stub_model(LootType, :name => "Armour", :show_on_player_list => true)
    armour_item = stub_model(Item, :name => "Phat BP", :eq2_item_id => "1234", :loot_type_id => armour.id)
    armour_item.stub!(:loot_type).and_return(armour)

    weapon = stub_model(LootType, :name => "Weapon", :show_on_player_list => true)
    weapon_item = stub_model(Item, :name => "Phat Sword", :eq2_item_id => "1235", :loot_type_id => weapon.id)
    weapon_item.stub!(:loot_type).and_return(weapon)

    armour_drop = stub_model(Drop,
                             :zone_name => "Wherever",
                             :mob_name => "Mob Name",
                             :player_name => "Player Name",
                             :item_name => "Phat BP",
                             :eq2_item_id => "1234",
                             :loot_type => armour)
    armour_drop.stub!(:item).and_return(armour_item)
    weapon_drop = stub_model(Drop,
                             :zone_name => "Wherever Next",
                             :mob_name => "Mob Name",
                             :player_name => "Player Name",
                             :item_name => "Phat Sword",
                             :eq2_item_id => "1235",
                             :loot_type => weapon)
    weapon_drop.stub!(:item).and_return(weapon_item)

    @player.stub!(:drops).and_return([armour_drop, weapon_drop])
  end

  it "should list the separate sections" do
    render

    rendered.should match(/Name/)
    rendered.should match(/Drop History/)
    rendered.should match(/Attendance History/)
  end

  it "should show the loot types" do
    render

    rendered.should match(/Weapon/)
    rendered.should match(/Armour/)
  end

  it "should list the loot items" do
    render

    rendered.should match(/Phat Sword/)
    rendered.should match(/Phat BP/)
  end
end
