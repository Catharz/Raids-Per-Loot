require 'spec_helper'

describe DropObserver do
  subject{ DropObserver.instance }
  let( :drop ) { mock_model(Drop) }

  describe '#after_save' do
    it 'uses the DropPostProcessor and SonyItemUpdater to update the character and item' do
      drop.should_receive(:item).at_least(2).times.and_return(mock_model(Item, :name => 'Sword'))
      Resque.should_receive(:enqueue).with(DropPostProcessor, drop.id)
      Resque.should_receive(:enqueue).with(SonyItemUpdater, drop.item.id)

      subject.after_save(drop)
    end
  end

  describe '#before_save' do
    it 'uses the DropPreProcessor to set the loot type' do
      Resque.should_receive(:enqueue).with(DropPreProcessor, drop.id)

      subject.before_save(drop)
    end
  end
end