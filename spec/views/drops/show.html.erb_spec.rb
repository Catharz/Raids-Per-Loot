require 'spec_helper'

describe "drops/show.html.erb" do
  fixtures :users, :services

  before(:each) do
    login_as :admin

    zone = stub_model(Zone, :name => "This Zone")
    assign(:zones, [zone])

    mob = stub_model(Mob, :zone => zone, :name => "This Mob")
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

    @drop = assign(:drop,
                   stub_model(Drop,
                              :zone => zone,
                              :mob => mob,
                              :character => character_one,
                              :item => item_one,
                              :loot_type => loot_type_one,
                              :loot_method => "r",
                              :chat => "blah, blah, blah",
                              :log_line => "Barmy looted a can of whoop'ass from the shiney green dragon"
                   ))
  end

  it "renders attributes in <p>" do
    render

    rendered.should match(/This Zone/)
    rendered.should match(/This Mob/)
    rendered.should match(/Character One/)
    rendered.should match(/Item One/)
    rendered.should match(/Random/)
    rendered.should match(/Armour/)
    rendered.should match(/blah, blah, blah/)
    rendered.should match(/Barmy looted a can of whoop\'ass from the shiney green dragon/)
  end
end
