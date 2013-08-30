require 'spec_helper'

describe SonyItemUpdater do
  fixtures :archetypes, :loot_types

  subject { SonyItemUpdater }
  let(:unknown) { LootType.find_by_name('Unknown') }
  let(:adornment) { LootType.find_by_name('Adornment') }
  let(:armour) { LootType.find_by_name('Armour') }
  let(:jewellery) { LootType.find_by_name('Jewellery') }
  let(:weapon) { LootType.find_by_name('Weapon') }
  let(:spell) { LootType.find_by_name('Spell') }
  let(:trash) { LootType.find_by_name('Trash') }
  let(:armour_item) { {
      type: 'Armor',
      slot_list: [name: 'Chest']
  }.with_indifferent_access }
  let(:jewellery_item) { {
      type: 'Armor',
      slot_list: [{name: 'Finger'}, {name: 'Charm'}]
  }.with_indifferent_access }
  let(:weapon_item) { {
      type: 'Weapon',
      slot_list: [{name: 'Primary'}, {name: 'Secondary'}],
      typeinfo: {classes: {bruiser: {displayname: 'Bruiser'},
                           monk: {displayname: 'Monk'}}}
  }.with_indifferent_access }
  let(:shield_item) { {
      type: 'Shield',
      slot_list: [name: 'Secondary']
  }.with_indifferent_access }
  let(:spell_item) { {
      type: 'Spell Scroll',
      typeinfo: {classes: {coercer: {displayname: 'Coercer'},
                           illusionist: {displayname: 'Illusionist'}}}
  }.with_indifferent_access }
  let(:trash_item) { {type: 'Item'}.with_indifferent_access }
  let(:war_rune_pattern) { {
      item_list: [{
                      type: 'Item',
                      name: 'War Rune: Smacky Smacky',
                      id: 4268162592
                  }]
  }.with_indifferent_access }
  let(:actual_war_rune) { {
      item_list: [
          {
              type: 'Item',
              name: 'Smacky Smacky',
              id: 70848758,
              typeinfo: {
                  slot_list: [{name: 'Primary'},
                              {name: 'Secondary'}],
                  classes: {brigand: {displayname: 'Brigand'},
                            swashbuckler: {displayname: 'Swashbucker'}}},
          }]
  }.with_indifferent_access }
  let(:war_rune_details) { actual_war_rune[:item_list][0] }
  let(:gore_imbued_pattern) { {type: 'Item', name: 'Gore-Imbued Leggings'}.
      with_indifferent_access }
  let(:cruor_forged_pattern) { {type: 'Item', name: 'Cruor-Forged Leggings'}.
      with_indifferent_access }
  let(:warborne_pattern) { {type: 'Item', name: 'Warborne Leggings'}.
      with_indifferent_access }

  after(:each) do
    Resque.queues.each { |queue_name| Resque.remove_queue queue_name }
  end

  describe '#perform' do
    it 'raises an exception if there is no internet connect' do
      item = FactoryGirl.create(:item, loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(false)
      expect {
        subject.perform(item.id)
      }.to raise_exception Exception, 'Internet connection unavailable.'
    end

    it 'raises an exception if it cannot find the item' do
      expect {
        subject.perform(-99)
      }.to raise_exception ActiveRecord::RecordNotFound,
                           "Couldn't find Item with id=-99"
    end

    it 'sets the correct loot type for adornment patterns' do
      item = FactoryGirl.create(:item, name: 'War Rune: Smacky Smacky',
                                loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SonyDataService.any_instance.should_receive(:item_data).
          with(item.eq2_item_id, 'json').and_return(war_rune_pattern)

      SOEData.should_receive(:get).and_return(actual_war_rune)
      subject.should_receive(:save_slots).with(item, war_rune_details)
      subject.should_receive(:save_archetypes).with(item, war_rune_details)

      item.should_receive(:update_attribute).with(:loot_type, adornment)
      item.should_receive(:build_external_data).with(data: war_rune_details)
      item.should_receive(:external_data).twice.and_return(war_rune_details)
      item.external_data.should_receive(:save)
      subject.perform(item.id)
    end

    it 'sets the correct loot type for armour' do
      item = FactoryGirl.create(:item, loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SonyDataService.any_instance.should_receive(:item_data).
          with(item.eq2_item_id, 'json').and_return(armour_item)

      subject.should_receive(:save_archetypes).with(item, armour_item)
      subject.should_receive(:save_slots).with(item, armour_item)

      item.should_receive(:update_attribute).with(:loot_type, armour)
      item.should_receive(:build_external_data).with(data: armour_item)
      item.should_receive(:external_data).twice.and_return(armour_item)
      item.external_data.should_receive(:save)
      subject.perform(item.id)
    end

    it 'sets the correct loot type for armour patterns' do
      [gore_imbued_pattern, cruor_forged_pattern, warborne_pattern].
          each do |pattern|
        item = FactoryGirl.create(:item, loot_type: unknown,
                                  name: pattern[:name])
        subject.should_receive(:internet_connection?).and_return(true)
        Item.should_receive(:find).with(item.id).and_return(item)
        SOEData.should_receive(:get).and_return({item_list: [pattern]}.
                                                    with_indifferent_access)

        item.should_receive(:update_attribute).with(:loot_type, armour)
        item.should_receive(:build_external_data).with(data: pattern)
        item.should_receive(:external_data).twice.and_return(pattern)
        item.external_data.should_receive(:save)
        subject.perform(item.id)
      end
    end

    it 'sets the correct loot type for jewellery' do
      item = FactoryGirl.create(:item, loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SonyDataService.any_instance.should_receive(:item_data).
          with(item.eq2_item_id, 'json').and_return(jewellery_item)

      subject.should_receive(:save_archetypes).with(item, jewellery_item)
      subject.should_receive(:save_slots).with(item, jewellery_item)

      item.should_receive(:update_attribute).with(:loot_type, jewellery)
      item.should_receive(:build_external_data).with(data: jewellery_item)
      item.should_receive(:external_data).twice.and_return(jewellery_item)
      item.external_data.should_receive(:save)
      subject.perform(item.id)
    end

    it 'sets the correct loot type for shields' do
      item = FactoryGirl.create(:item, loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SonyDataService.any_instance.should_receive(:item_data).
          with(item.eq2_item_id, 'json').and_return(shield_item)

      subject.should_receive(:save_archetypes).with(item, shield_item)
      subject.should_receive(:save_slots).with(item, shield_item)

      item.should_receive(:update_attribute).with(:loot_type, weapon)
      item.should_receive(:build_external_data).with(data: shield_item)
      item.should_receive(:external_data).twice.and_return(shield_item)
      item.external_data.should_receive(:save)
      subject.perform(item.id)
    end

    it 'sets the correct loot type for spells' do
      item = FactoryGirl.create(:item, loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SonyDataService.any_instance.should_receive(:item_data).
          with(item.eq2_item_id, 'json').and_return(spell_item)

      subject.should_receive(:save_archetypes).with(item, spell_item)

      item.should_receive(:update_attribute).with(:loot_type, spell)
      item.should_receive(:build_external_data).with(data: spell_item)
      item.should_receive(:external_data).twice.and_return(spell_item)
      item.external_data.should_receive(:save)
      subject.perform(item.id)
    end

    it 'sets the correct loot type for weapons' do
      item = FactoryGirl.create(:item, loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SonyDataService.any_instance.should_receive(:item_data).
          with(item.eq2_item_id, 'json').and_return(weapon_item)

      subject.should_receive(:save_archetypes).with(item, weapon_item)
      subject.should_receive(:save_slots).with(item, weapon_item)

      item.should_receive(:update_attribute).with(:loot_type, weapon)
      item.should_receive(:build_external_data).with(data: weapon_item)
      item.should_receive(:external_data).twice.and_return(weapon_item)
      item.external_data.should_receive(:save)
      subject.perform(item.id)
    end

    it 'sets the correct loot type for trash drops' do
      item = FactoryGirl.create(:item, loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SonyDataService.any_instance.should_receive(:item_data).
          with(item.eq2_item_id, 'json').and_return(trash_item)

      item.should_receive(:update_attribute).with(:loot_type, trash)
      item.should_receive(:build_external_data).with(data: trash_item)
      item.should_receive(:external_data).twice.and_return(trash_item)
      item.external_data.should_receive(:save)
      subject.perform(item.id)
    end

    it 'saves the slots for an item' do
      item = FactoryGirl.create(:item, loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SonyDataService.any_instance.should_receive(:item_data).
          with(item.eq2_item_id, 'json').and_return(jewellery_item)

      subject.should_receive(:save_archetypes).with(item, jewellery_item)

      item.should_receive(:update_attribute).with(:loot_type, jewellery)
      item.should_receive(:build_external_data).with(data: jewellery_item)
      item.should_receive(:external_data).twice.and_return(jewellery_item)
      item.external_data.should_receive(:save)

      subject.perform(item.id)

      ItemsSlot.all.collect { |is| [is.slot_name, is.item_name] }.
          should match_array [['Finger', item.name], ['Charm', item.name]]
    end

    it 'saves the slots for an adornment' do
      item = FactoryGirl.create(:item, name: 'War Rune: Smacky Smacky',
                                loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SOEData.should_receive(:get).
          with('/json/get/eq2/item/' +
                   '?id=0&c:show=type,displayname,typeinfo.classes,' +
                   'typeinfo.slot_list,slot_list').
          and_return(war_rune_pattern)
      SOEData.should_receive(:get).
          with('/json/get/eq2/item/' +
                   '?displayname=Smacky+Smacky&c:show=type,displayname,' +
                   'typeinfo.classes,typeinfo.slot_list,slot_list').
          and_return(actual_war_rune)

      subject.should_receive(:save_archetypes).with(item, war_rune_details)

      item.should_receive(:update_attribute).with(:loot_type, adornment)
      item.should_receive(:build_external_data).with(data: war_rune_details)
      item.should_receive(:external_data).twice.and_return(war_rune_details)
      item.external_data.should_receive(:save)

      subject.perform(item.id)

      ItemsSlot.all.collect { |is| [is.slot_name, is.item_name] }.
          should match_array [['Primary', item.name], ['Secondary', item.name]]
    end

    it 'saves the archetypes for an item' do
      item = FactoryGirl.create(:item, loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SonyDataService.any_instance.should_receive(:item_data).
          with(item.eq2_item_id, 'json').and_return(weapon_item)

      subject.should_receive(:save_slots).with(item, weapon_item)

      item.should_receive(:update_attribute).with(:loot_type, weapon)
      item.should_receive(:build_external_data).with(data: weapon_item)
      item.should_receive(:external_data).twice.and_return(weapon_item)
      item.external_data.should_receive(:save)

      subject.perform(item.id)

      ArchetypesItem.all.collect { |ai| [ai.archetype_name, ai.item_name] }.
          should match_array [['Bruiser', item.name], ['Monk', item.name]]
    end

    it 'saves the archetypes for an adornment' do
      item = FactoryGirl.create(:item, name: 'War Rune: Smacky Smacky',
                                loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SOEData.should_receive(:get).
          with('/json/get/eq2/item/' +
                   '?id=0&c:show=type,displayname,' +
                   'typeinfo.classes,typeinfo.slot_list,slot_list').
          and_return(war_rune_pattern)
      SOEData.should_receive(:get).
          with('/json/get/eq2/item/' +
                   '?displayname=Smacky+Smacky&c:show=type,displayname,' +
                   'typeinfo.classes,typeinfo.slot_list,slot_list').
          and_return(actual_war_rune)

      subject.should_receive(:save_slots).with(item, war_rune_details)

      item.should_receive(:update_attribute).with(:loot_type, adornment)
      item.should_receive(:build_external_data).with(data: war_rune_details)
      item.should_receive(:external_data).twice.and_return(war_rune_details)
      item.external_data.should_receive(:save)

      subject.perform(item.id)

      ArchetypesItem.all.collect { |ai| [ai.archetype_name, ai.item_name] }.
          should match_array [['Brigand', item.name],
                              ['Swashbuckler', item.name]]
    end

    it 'saves the archetypes for a spell' do
      item = FactoryGirl.create(:item, loot_type: unknown)
      subject.should_receive(:internet_connection?).and_return(true)
      Item.should_receive(:find).with(item.id).and_return(item)
      SonyDataService.any_instance.should_receive(:item_data).
          with(item.eq2_item_id, 'json').and_return(spell_item)

      item.should_receive(:update_attribute).with(:loot_type, spell)
      item.should_receive(:build_external_data).with(data: spell_item)
      item.should_receive(:external_data).twice.and_return(spell_item)
      item.external_data.should_receive(:save)

      subject.perform(item.id)

      ArchetypesItem.all.collect { |ai| [ai.archetype_name, ai.item_name] }.
          should match_array [['Coercer', item.name],
                              ['Illusionist', item.name]]
    end
  end
end