require 'spec_helper'

describe TrashDropFixer do
  fixtures :loot_types
  subject { TrashDropFixer }

  after(:each) do
    Resque.queues.each { |queue_name| Resque.remove_queue queue_name }
  end

  describe '#perform' do
    it 'updates the loot_method of drops of trash items' do
      trash = LootType.find_by_name('Trash')
      item = FactoryGirl.create(:item, loot_type: trash)
      3.times { FactoryGirl.create(:drop, item: item, loot_method: 'n') }

      Item.of_type('Trash').includes(:drops).
          where('drops.loot_method <> ?', 't').count.should eq 1
      Drop.group(:loot_method).count.should == {'n' => 3}

      subject.perform

      Item.of_type('Trash').includes(:drops).
          where('drops.loot_method <> ?', 't').count.should eq 0
      Drop.group(:loot_method).count.should == {'t' => 3}
    end
  end
end