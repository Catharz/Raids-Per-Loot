require 'spec_helper'
include PlayersHelper

describe PlayersHelper do
  before(:each) do
    @armour_type = Factory.create(:loot_type, :name => "Armour", :show_on_player_list => true)
    @weapon_type = Factory.create(:loot_type, :name => "Weapon", :show_on_player_list => true)
    @junk_type = Factory.create(:loot_type, :name => "Junk", :show_on_player_list => false)
  end

  describe "generate heading" do
    it "only includes loot types that we want to show" do
      heading = generate_headings
      heading.should match(/Armour/)
      heading.should match(/Weapon/)
    end

    it "does not include loot types that we do not want to show" do
      heading = generate_headings
      heading.should_not match(/Junk/)
    end
  end

  describe "display loot rates" do
    it "only calculates rates for loot types that we want to show" do
      player = Factory.create(:player, :name => "Fred")

      zone = Factory.create(:zone, :name => "Wherever")
      mob = Factory.create(:mob, :name => "Whoever")
      zone.mobs << mob

      raid = Factory.create(:raid)
      instance = Factory.create(:instance, :raid_id => raid.id, :zone_id => zone.id)

      player.instances << instance

      item_one = Factory.create(:item, :name => "Bag of Poo", :loot_type_id => @junk_type.id, :eq2_item_id => "1234")
      item_two = Factory.create(:item, :name => "Breast Plate", :loot_type_id => @armour_type.id, :eq2_item_id => "1235")

      drop_one = Factory.create(:drop,
                                :zone_name => zone.name,
                                :mob_name => mob.name,
                                :player_name => player.name,
                                :item_name => item_one.name,
                                :eq2_item_id => item_one.eq2_item_id,
                                :drop_time => DateTime.now)
      drop_two = Factory.create(:drop,
                                :zone_name => zone.name,
                                :mob_name => mob.name,
                                :player_name => player.name,
                                :item_name => item_two.name,
                                :eq2_item_id => item_two.eq2_item_id,
                                :drop_time => DateTime.now)

      player.drops << drop_one
      player.drops << drop_two

      loot_rates = display_loot_rates(player)
      loot_rates.should match(/1.*1/)
      loot_rates.should_not match(/1.*1.*1/)
    end
  end
end
