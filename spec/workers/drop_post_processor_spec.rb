require 'spec_helper'

describe DropPostProcessor do
  subject { DropPostProcessor }

  describe '#perform' do
    it 'recalculates the loot rate for the character' do
      character = FactoryGirl.create(:character)
      drop = FactoryGirl.create(:drop, character: character)

      Drop.should_receive(:find).with(drop.id).and_return(drop)
      drop.character.should_receive(:recalculate_loot_rates)
      drop.character.should_receive(:player).and_return(nil)

      subject.perform(drop.id)
    end

    it 'recalculates the loot rate for the player' do
      player = FactoryGirl.create(:player)
      character = FactoryGirl.create(:character, player: player)
      drop = FactoryGirl.create(:drop, character: character)

      Drop.should_receive(:find).with(drop.id).and_return(drop)
      character.should_receive(:recalculate_loot_rates)
      character.should_receive(:player).at_least(2).times.and_return(player)
      player.should_receive(:recalculate_loot_rates)

      subject.perform(drop.id)
    end
  end
end