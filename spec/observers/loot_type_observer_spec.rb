require 'spec_helper'

describe LootTypeObserver do
  subject{ LootTypeObserver.instance }
  let( :loot_type ) { mock_model(LootType, :name => 'Anything', :default_loot_method => 't') }

  describe '#after_save' do
    describe "updates items to that loot type" do
      it "sets the drop loot_method to trash if the loot type is trash" do
        trash_drop = mock_model(Drop, :name => "Trash Drop", :loot_method => 'n')

        loot_type.should_receive(:drops).once.and_return([trash_drop])
        loot_type.should_receive(:items).once.and_return([])

        trash_drop.should_receive(:update_attribute).with(:loot_method, 't')

        subject.after_save(loot_type)
      end

      it "sets the loot_type of drops if not already set" do
        trash_drop = mock_model(Drop, :name => "Trash Drop", :loot_method => 'n')
        trash_item = mock_model(Item, :name => "Trash Drop")

        loot_type.should_receive(:drops).once.and_return([trash_drop])
        loot_type.should_receive(:items).once.and_return([trash_item])
        trash_drop.should_receive(:update_attribute).with(:loot_method, 't')
        trash_drop.should_receive(:loot_type).and_return(nil)
        trash_item.should_receive(:drops).and_return([trash_drop])

        trash_drop.should_receive(:update_attribute).with(:loot_type, loot_type)

        subject.after_save(loot_type)
      end
    end
  end
end