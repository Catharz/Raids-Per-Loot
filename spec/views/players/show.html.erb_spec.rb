require 'spec_helper'
require 'date'

describe "players/show.html.erb" do
  fixtures :users

  before(:each) do
    login_as users(:quentin)

    zone_1 = stub_model(Zone, :name => "Wherever")
    zone_2 = stub_model(Zone, :name => "Wherever Next")
    instance_1 = stub_model(Instance, :start_time => DateTime.parse("01/01/2011 18:00"), :end_time => DateTime.parse("01/01/2011 20:00"))
    instance_1.zone = zone_1
    instance_2 = stub_model(Instance, :start_time => DateTime.parse("01/01/2011 20:05"), :end_time => DateTime.parse("01/01/2011 22:00"))
    instance_2.zone = zone_2
    assign(:player_instances, {Date.parse("01/01/2012") => [instance_1, instance_2]})

    armour = stub_model(LootType, :name => "Armour", :show_on_player_list => true)
    weapon = stub_model(LootType, :name => "Weapon", :show_on_player_list => true)

    armour_item = stub_model(Item, :name => "Phat BP", :eq2_item_id => "1234", :loot_type_id => armour.id)
    weapon_item = stub_model(Item, :name => "Phat Sword", :eq2_item_id => "1235", :loot_type_id => weapon.id)

    drop_1 = stub_model(Drop,
                        :zone_name => "Wherever",
                        :mob_name => "Mob Name",
                        :player_name => "Player Name",
                        :item_name => "Phat BP",
                        :eq2_item_id => "1234",
                        :item_id => armour_item.id
    )
    drop_2 = stub_model(Drop,
                        :zone_name => "Wherever Next",
                        :mob_name => "Mob Name",
                        :player_name => "Player Name",
                        :item_name => "Phat Sword",
                        :eq2_item_id => "1235",
                        :item_id => weapon_item.id
    )
    assign(:player_drops, {"Armour" => [drop_1], "Weapons" => [drop_2]})

    @player = assign(:player, stub_model(Player,
                                         :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/Weapons/)
    rendered.should match(/Armour/)
  end
end
