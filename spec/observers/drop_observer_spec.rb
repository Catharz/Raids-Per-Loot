require 'spec_helper'

describe DropObserver do
  subject{ DropObserver.instance }
  let( :drop ) { mock_model(Drop) }

  describe '#after_save' do
    it "updates the character and item" do
      drop.should_receive(:character).at_least(2).times.and_return(mock_model(Character, :name => "Freddy"))
      drop.should_receive(:item).at_least(2).times.and_return(mock_model(Item, :name => "Sword"))
      drop.item.should_receive( :update_item_details )
      drop.character.should_receive( :recalculate_loot_rates )
      drop.character.should_receive(:player).at_least(2).times.and_return(mock_model(Player, :name => "Freddy"))
      drop.character.player.should_receive( :recalculate_loot_rates )

      subject.after_save(drop)
    end
  end
end