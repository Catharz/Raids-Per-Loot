require 'spec_helper'

describe "drops/index.html.erb" do
  fixtures :users, :services

  before(:each) do
    login_as :admin

    zone = stub_model(Zone, :name => "Zone Name")
    assign(:zones, [zone])

    mob = stub_model(Mob, :zone => zone, :name => "Mob Name")
    assign(:mobs, [mob])

    character_one = stub_model(Character, :player_id => 1, :archetype_id => 1, :name => "Character One")
    character_two = stub_model(Character, :player_id => 1, :archetype_id => 2, :name => "Character Two")
    assign(:characters, [character_one, character_two])

    loot_type_one = stub_model(LootType, :name => "Armour")
    loot_type_two = stub_model(LootType, :name => "Jewellery")
    assign(:loot_types, [loot_type_one, loot_type_two])

    item_one = stub_model(Item, :name => "Item One", :eq2_item_id => "eq2 item 1", :loot_type => loot_type_one)
    item_two = stub_model(Item, :name => "Item Two", :eq2_item_id => "eq2 item 2", :loot_type => loot_type_two)
    assign(:items, [item_one, item_two])

    assign(:drops, [
        stub_model(Drop,
                   :zone => zone,
                   :mob => mob,
                   :character => character_one,
                   :item => item_one,
                   :loot_type => loot_type_one,
                   :loot_method => "n"
        ),
        stub_model(Drop,
                   :zone => zone,
                   :mob => mob,
                   :character => character_two,
                   :item => item_two,
                   :loot_type => loot_type_two,
                   :loot_method => "r"
        )
    ])
  end

  it "renders the table headings" do
    render

    rendered.should contain("Zone Name")
    rendered.should contain("Mob Name")
    rendered.should contain("Item Name")
    rendered.should contain("Character Name")
    rendered.should contain("Loot Type")
    rendered.should contain("Zone Name")
    rendered.should contain("Mob Name")
    rendered.should contain("Drop Time")
    rendered.should contain("Loot Method")
  end
end
