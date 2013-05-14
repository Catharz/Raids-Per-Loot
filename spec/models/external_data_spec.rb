require 'spec_helper'

describe ExternalData do
  context 'characters' do
    describe '#data' do
      it 'initializes when you read it' do
        character = FactoryGirl.create(:character)
        ed = FactoryGirl.create(:character_external_data, character: character)

        ed.data.should_not be_nil
      end

      it 'stores a hash' do
        character = FactoryGirl.create(:character)
        ed = FactoryGirl.create(:character_external_data, character: character)

        ed.data.should be_a Hash
      end
    end
  end

  context 'items' do
    describe '#data' do
      it 'initializes when you read it' do
        item = FactoryGirl.create(:item)
        ed = FactoryGirl.create(:item_external_data, item: item)

        ed.data.should_not be_nil
      end

      it 'stores a hash' do
        item = FactoryGirl.create(:item)
        ed = FactoryGirl.create(:item_external_data, item: item)

        ed.data.should be_a Hash
      end
    end
  end
end