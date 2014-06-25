require 'spec_helper'

describe LootTypeItemsUpdater do
  subject { LootTypeItemsUpdater }
  let(:trash_loot_type) { FactoryGirl.create(:loot_type,
                                             name: 'Trash Drop',
                                             default_loot_method: 't') }
  let(:bank_loot_type) { FactoryGirl.create(:loot_type,
                                            name: 'Banked Item',
                                            default_loot_method: 'g') }

  after(:each) do
    Resque.queues.each { |queue_name| Resque.remove_queue queue_name }
  end

  describe '#perform' do
    describe 'updates items to that loot type' do
      it 'sets the drop loot_method to trash if the loot type is trash' do
        trash_drop = FactoryGirl.create(:drop,
                                        loot_method: 'n',
                                        loot_type: trash_loot_type)

        subject.perform(trash_loot_type.id)

        trash_drop.reload
        trash_drop.loot_method.should eq 't'
      end

      it 'sets the drop loot_method to guild bank when required' do
        bank_drop = FactoryGirl.create(:drop, loot_method: 'n',
                                       loot_type: bank_loot_type)

        subject.perform(bank_loot_type.id)

        bank_drop.reload
        bank_drop.loot_method.should eq 'g'
      end

      it 'sets the loot_type of trash drops to trash if not already set' do
        trash_item = FactoryGirl.create(:item,
                                        name: 'Trash Item',
                                        loot_type: trash_loot_type)
        trash_drop = FactoryGirl.create(:drop,
                                        loot_method: 'n',
                                        item: trash_item,
                                        loot_type: bank_loot_type)

        subject.perform(trash_loot_type.id)

        trash_drop.reload
        trash_drop.loot_type.should eq trash_loot_type
      end

      it 'sets the loot_type of bank drops to bank if not already set' do
        bank_item = FactoryGirl.create(:item,
                                       name: 'Bank Item',
                                       loot_type: bank_loot_type)
        bank_drop = FactoryGirl.create(:drop,
                                       loot_method: 'n',
                                       item: bank_item,
                                       loot_type: trash_loot_type)

        subject.perform(bank_loot_type.id)

        bank_drop.reload
        bank_drop.loot_type.should eq bank_loot_type
      end
    end
  end
end
