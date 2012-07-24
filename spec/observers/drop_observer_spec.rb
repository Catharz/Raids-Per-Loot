require 'spec_helper'

describe DropObserver do
  subject{ DropObserver.instance }
  let( :drop ) { mock_model(Drop) }

  describe '#after_save' do
    it "updates the character and item" do
      drop.should_receive(:character).at_least(2).times.and_return(mock_model(Character, :name => "Freddy"))
      drop.should_receive(:item).at_least(2).times.and_return(mock_model(Item, :name => "Sword"))
      drop.item.should_receive( :fetch_soe_item_details )
      drop.character.should_receive( :recalculate_loot_rates )
      drop.character.should_receive(:player).at_least(2).times.and_return(mock_model(Player, :name => "Freddy"))
      drop.character.player.should_receive( :recalculate_loot_rates )

      subject.after_save(drop)
    end
  end

  describe '#before_save' do
    it "sets the loot type" do
      drop.should_receive(:loot_type).at_least(2).times.and_return(nil)
      drop.should_receive(:item).at_least(2).times.and_return(mock_model(Item, :name => "Blue Shard"))
      drop.item.should_receive(:loot_type).at_least(2).times.and_return(mock_model(LootType, :name => "Trash"))
      drop.should_receive(:loot_type=).with(drop.item.loot_type)

      subject.before_save(drop)
    end

    it "sets the loot method to the default loot method" do
      drop.should_receive(:loot_method).and_return(nil)
      drop.should_receive(:loot_type).at_least(2).times.and_return(mock_model(LootType, :name => "Trash", :default_loot_method => 't'))
      drop.should_receive(:loot_method=).with(drop.loot_type.default_loot_method)

      subject.before_save(drop)
    end
  end
end