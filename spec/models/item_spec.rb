require 'spec_helper'

describe Item do
  fixtures :loot_types

  let(:armour) { LootType.find_by_name('Armour' ) }
  let(:jewellery) { LootType.find_by_name('Jewellery' ) }
  let(:weapon) { LootType.find_by_name('Weapon' ) }
  let(:armour_item) { FactoryGirl.create(:item, loot_type: armour) }
  let(:jewellery_item) { FactoryGirl.create(:item, loot_type: jewellery) }
  let(:weapon_item) { FactoryGirl.create(:item, loot_type: weapon) }

  describe 'scopes' do
    describe 'of_type' do
      it 'finds all items by default' do
        Item.of_type(nil).
            should match_array [armour_item, jewellery_item, weapon_item]
      end

      it 'finds items by loot type name' do
        Item.of_type('Armour').should eq [armour_item]
      end
    end

    describe 'by_loot_type' do
      it 'finds all items by default' do
        Item.by_loot_type(nil).
            should match_array [armour_item, jewellery_item, weapon_item]
      end

      it 'finds items by loot type id' do
        Item.by_loot_type(jewellery.id).should eq [jewellery_item]
      end
    end

    describe 'by_name' do
      it 'finds all items by default' do
        Item.by_name(nil).
            should match_array [armour_item, jewellery_item, weapon_item]
      end

      it 'finds items by item name' do
        Item.by_name(weapon_item.name).should eq [weapon_item]
      end
    end

    describe 'by_eq2_item_id' do
      it 'finds all items by default' do
        Item.by_eq2_item_id(nil).
            should match_array [armour_item, jewellery_item, weapon_item]
      end

      it 'finds items by item name' do
        Item.by_eq2_item_id(armour_item.eq2_item_id).should eq [armour_item]
      end
    end
  end

  describe 'instance methods' do
    describe '#class_names' do
      it 'calls consolidate_archetypes with the items archetypes' do
        item = FactoryGirl.create(:item)
        item.archetypes << FactoryGirl.create(:archetype)

        item.should_receive(:consolidate_archetypes).with(item.archetypes)
        item.class_names
      end
    end

    describe '#slot_names' do
      it 'returns a list of slots' do
        ear = FactoryGirl.create(:slot, name: 'Ear')
        finger = FactoryGirl.create(:slot, name: 'Finger')

        item = FactoryGirl.create(:item)
        item.should_receive(:slots).twice.and_return([ear, finger])
        item.slot_names.should eq 'Ear, Finger'
      end
    end

    describe '#eq2wire_data' do
      it 'returns nothing if there is no internet connection' do
        item = FactoryGirl.create(:item)
        item.should_receive(:internet_connection?).and_return(false)

        item.eq2wire_data.should be_nil
      end

      it 'calls the Scraper if there is an internet connection' do
        item = FactoryGirl.create(:item)
        item.should_receive(:internet_connection?).and_return(true)

        Scraper.should_receive(:get).
            with("http://u.eq2wire.com/item/index/#{item.eq2_item_id}",
                 '.itemd_detailwrap')
        item.eq2wire_data
      end
    end
  end
end