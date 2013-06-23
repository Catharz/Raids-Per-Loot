require 'spec_helper'

describe TrashDropFixer do
  subject { TrashDropFixer }

  describe '#perform' do
    it 'updates the loot_method of drops of trash items' do
      trash = FactoryGirl.create(:loot_type, name: 'Trash')
      item = FactoryGirl.create(:item, loot_type: trash)
      10.times { FactoryGirl.create(:drop, item: item, loot_method: 'n') }

      Item.of_type('Trash').includes(:drops).where('drops.loot_method <> ?', 't').count.should eq 1
      Drop.group(:loot_method).count.should == {'n' => 10}

      subject.perform

      Item.of_type('Trash').includes(:drops).where('drops.loot_method <> ?', 't').count.should eq 0
      Drop.group(:loot_method).count.should == {'t' => 10}
    end
  end
end