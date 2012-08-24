require 'spec_helper'

describe LootTypeObserver do
  subject{ LootTypeObserver.instance }
  let( :trash_loot_type ) { mock_model(LootType, :name => 'Trash Drop', :default_loot_method => 't') }
  let( :bank_loot_type ) { mock_model(LootType, :name => 'Banked Item', :default_loot_method => 'g') }

  describe '#after_save' do
    describe "updates items to that loot type" do
      it "sets the drop loot_method to trash if the loot type is trash" do
        trash_drop = mock_model(Drop, :name => "Trash Drop", :loot_method => 'n')

        trash_loot_type.should_receive(:drops).once.and_return([trash_drop])
        trash_loot_type.should_receive(:items).once.and_return([])

        trash_drop.should_receive(:update_attribute).with(:loot_method, 't')

        subject.after_save(trash_loot_type)
      end

      it "sets the drop loot_method to guild bank if the loot type is guild bank" do
        bank_drop = mock_model(Drop, :name => "Bank Drop", :loot_method => 'n')

        bank_loot_type.should_receive(:drops).once.and_return([bank_drop])
        bank_loot_type.should_receive(:items).once.and_return([])

        bank_drop.should_receive(:update_attribute).with(:loot_method, 'g')

        subject.after_save(bank_loot_type)
      end

      it "sets the loot_type of trash drops to trash if not already set" do
        trash_drop = mock_model(Drop, :name => "Trash Drop", :loot_method => 'n')
        trash_item = mock_model(Item, :name => "Trash Drop")

        trash_loot_type.should_receive(:drops).once.and_return([trash_drop])
        trash_loot_type.should_receive(:items).once.and_return([trash_item])
        trash_drop.should_receive(:update_attribute).with(:loot_method, 't')
        trash_drop.should_receive(:loot_type).and_return(nil)
        trash_item.should_receive(:drops).and_return([trash_drop])

        trash_drop.should_receive(:update_attribute).with(:loot_type, trash_loot_type)

        subject.after_save(trash_loot_type)
      end

      it "sets the loot_type of bank drops to bank if not already set" do
        trash_drop = mock_model(Drop, :name => "Trash Drop", :loot_method => 'n')
        trash_item = mock_model(Item, :name => "Trash Drop")

        bank_loot_type.should_receive(:drops).once.and_return([trash_drop])
        bank_loot_type.should_receive(:items).once.and_return([trash_item])
        trash_drop.should_receive(:update_attribute).with(:loot_method, 'g')
        trash_drop.should_receive(:loot_type).and_return(nil)
        trash_item.should_receive(:drops).and_return([trash_drop])

        trash_drop.should_receive(:update_attribute).with(:loot_type, bank_loot_type)

        subject.after_save(bank_loot_type)
      end
    end
  end
end