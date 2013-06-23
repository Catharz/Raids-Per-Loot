require 'spec_helper'

describe LootTypeObserver do
  subject{ LootTypeObserver.instance }

  describe '#after_save' do
    it 'uses the Resque and the LootTypesItemsUpdater to perform the update' do
      trash_loot_type = FactoryGirl.create(:loot_type, :default_loot_method => 't')
      Resque.should_receive(:enqueue).with(LootTypeItemsUpdater, trash_loot_type.id)

      subject.after_save(trash_loot_type)
    end
  end
end