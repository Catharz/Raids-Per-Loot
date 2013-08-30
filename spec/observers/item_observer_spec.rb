require 'spec_helper'

describe ItemObserver do
  subject{ ItemObserver.instance }
  let( :item ) { mock_model(Item) }

  describe '#after_save' do
    it 'updates the loot type of drops when they do not match' do
      armour = mock_model(LootType, name: 'Armour')
      weapon = mock_model(LootType, name: 'Weapon')
      drop = mock_model(Drop)
      drop.should_receive(:loot_type).and_return(weapon)
      item.should_receive(:drops).and_return([drop])
      item.should_receive(:loot_type).at_least(3).times.and_return(armour)
      drop.should_receive(:update_attribute).with(:loot_type, armour)

      subject.after_save(item)
    end

    it 'does not update the loot type of drops when they do match' do
      armour = mock_model(LootType, name: 'Armour')
      drop = mock_model(Drop)
      drop.should_receive(:loot_type).and_return(armour)
      item.should_receive(:drops).and_return([drop])
      item.should_receive(:loot_type).at_least(2).times.and_return(armour)
      drop.should_not_receive(:update_attribute).with(:loot_type, armour)

      subject.after_save(item)
    end

    it 'sets drop loot method to trash if loot type is trash' do
      trash = mock_model(LootType, name: 'Trash')
      drop = mock_model(Drop)
      drop.should_receive(:loot_type).and_return(nil)
      item.should_receive(:drops).and_return([drop])
      item.should_receive(:loot_type).at_least(3).times.and_return(trash)
      drop.should_receive(:update_attribute).with(:loot_type, trash)
      drop.should_receive(:loot_method).and_return(nil)
      drop.should_receive(:update_attribute).with(:loot_method, 't')

      subject.after_save(item)
    end
  end
end