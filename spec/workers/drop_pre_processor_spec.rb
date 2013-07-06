require 'spec_helper'

describe DropPreProcessor do
  subject { DropPreProcessor }

  after(:each) do
    Resque.queues.each { |queue_name| Resque.remove_queue queue_name }
  end

  describe '#perform' do
    it 'sets the drops loot_type to the items loot_type' do
      bank_loot_type = FactoryGirl.create(:loot_type, name: 'Bank', default_loot_method: 'g')
      bank_item = FactoryGirl.create(:item, loot_type: bank_loot_type)

      drop = FactoryGirl.create(:drop)
      Drop.should_receive(:find).and_return(drop)
      drop.should_receive(:loot_type).and_return(nil)
      drop.should_receive(:item).exactly(4).times.and_return(bank_item)

      drop.should_receive(:loot_type=).with(bank_loot_type)
      drop.should_receive(:loot_method=).with('g')

      subject.perform(drop.id)
    end
  end
end