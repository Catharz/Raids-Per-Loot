require 'spec_helper'

describe DropsQuery do
  fixtures :loot_types, :difficulties, :archetypes

  describe '#drops' do
    before(:each) do
      zone_names = %w{Here There Everywhere}
      mob_names = %w{Him Her Them}
      item_names = %w{Sword Shield Ring}
      loot_type_names = %w{Weapon Armour Jewellery}
      character_names = %w{Fred Barney Wilma}

      @zones = Array.new(3) { |n| FactoryGirl.create(:zone, name: zone_names[n]) }
      @mobs = Array.new(3) { |n| FactoryGirl.create(:mob, zone: @zones[n], name: mob_names[n]) }
      @items = Array.new(3) { |n| FactoryGirl.create(:item,
                                                     name: "#{item_names[n]} #{n}",
                                                     loot_type: LootType.find_by_name(loot_type_names[n])) }
      @characters = Array.new(3) { |n| FactoryGirl.create(:character, name: character_names[n]) }
      @drops = Array.new(9) { |n| FactoryGirl.create(:drop,
                                                     zone: @zones[n % 3],
                                                     mob: @mobs[n % 3],
                                                     item: @items[n % 3],
                                                     loot_type: LootType.find_by_name(loot_type_names[n % 3]),
                                                     character: @characters[n % 3]) }
    end

    it 'returns a list of drops' do
      dq = DropsQuery.new
      dq.drops.should match_array @drops
    end

    it 'sets the total number of drops' do
      dq = DropsQuery.new
      dq.total_records.should eq 9
    end

    it 'sets the number of filtered drops' do
      dq = DropsQuery.new(sSearch: @characters[1].name)
      dq.total_entries.should eq 3
    end
  end

  describe 'searching' do
    before(:each) do
      zone_names = %w{Here There Everywhere}
      mob_names = %w{Him Her Them}
      item_names = %w{Sword Shield Ring}
      loot_type_names = %w{Weapon Armour Jewellery}
      character_names = %w{Fred Barney Wilma}

      @zones = Array.new(3) { |n| FactoryGirl.create(:zone, name: zone_names[n]) }
      @mobs = Array.new(3) { |n| FactoryGirl.create(:mob, zone: @zones[n], name: mob_names[n]) }
      @items = Array.new(3) { |n| FactoryGirl.create(:item,
                                                     name: "#{item_names[n]} #{n}",
                                                     loot_type: LootType.find_by_name(loot_type_names[n])) }
      @characters = Array.new(3) { |n| FactoryGirl.create(:character, name: character_names[n]) }
      @drops = Array.new(9) { |n| FactoryGirl.create(:drop,
                                                     zone: @zones[n % 3],
                                                     mob: @mobs[n % 3],
                                                     item: @items[n % 3],
                                                     loot_type: LootType.find_by_name(loot_type_names[n % 3]),
                                                     character: @characters[n % 3]) }
    end

    it 'by zone name' do
      dq = DropsQuery.new(sSearch: 'There')
      dq.drops.should match_array Drop.by_zone(@zones[1].id)
    end

    it 'by mob name' do
      dq = DropsQuery.new(sSearch: 'Them')
      dq.drops.should match_array Drop.by_mob(@mobs[2].id)
    end

    it 'by item name' do
      dq = DropsQuery.new(sSearch: 'Sword')
      dq.drops.should match_array Drop.by_item(@items[0].id)
    end

    it 'by character name' do
      dq = DropsQuery.new(sSearch: 'Barney')
      dq.drops.should match_array Drop.by_character(@characters[1].id)
    end

    it 'by loot type name' do
      dq = DropsQuery.new(sSearch: 'Jewellery')
      dq.drops.should match_array Drop.of_type('Jewellery')
    end
  end

  describe 'sorting' do
    it 'sorts ascending by default' do
      items = Array.new(3) { |n| FactoryGirl.create(:item, name: "item_#{3 - n}") }
      drops = Array.new(3) { |n| FactoryGirl.create(:drop, item: items[n])}

      dq = DropsQuery.new(iSortCol_0: 0)
      dq.drops.should eq drops.reverse
    end

    it 'sorts descending if requested' do
      characters = Array.new(3) { |n| FactoryGirl.create(:character, name: "character_#{n}") }
      drops = Array.new(3) { |n| FactoryGirl.create(:drop, character: characters[n]) }

      dq = DropsQuery.new(iSortCol_0: 1, sSortDir_0: 'desc')
      dq.drops.should eq drops.reverse
    end

    context 'sorts by' do
      it 'item name' do
        items = Array.new(3) { |n| FactoryGirl.create(:item, name: "item_#{3 - n}") }
        drops = Array.new(3) { |n| FactoryGirl.create(:drop, item: items[n])}

        dq = DropsQuery.new(iSortCol_0: 0)
        dq.drops.should eq drops.reverse
      end

      it 'character name' do
        characters = Array.new(3) { |n| FactoryGirl.create(:character, name: "character_#{3 - n}") }
        drops = Array.new(3) { |n| FactoryGirl.create(:drop, character: characters[n])}

        dq = DropsQuery.new(iSortCol_0: 1)
        dq.drops.should eq drops.reverse
      end

      it 'loot type name' do
        loot_types = LootType.order(:name).all.reverse
        drops = Array.new(3) { |n| FactoryGirl.create(:drop, loot_type: loot_types[n])}

        dq = DropsQuery.new(iSortCol_0: 2)
        dq.drops.should eq drops.reverse
      end

      it 'zone name' do
        zones = Array.new(3) { |n| FactoryGirl.create(:zone, name: "zone_#{3 - n}") }
        drops = Array.new(3) { |n| FactoryGirl.create(:drop, zone: zones[n])}

        dq = DropsQuery.new(iSortCol_0: 3)
        dq.drops.should eq drops.reverse
      end

      it 'mob name' do
        mobs = Array.new(3) { |n| FactoryGirl.create(:mob, name: "mob_#{3 - n}") }
        drops = Array.new(3) { |n| FactoryGirl.create(:drop, mob: mobs[n])}

        dq = DropsQuery.new(iSortCol_0: 4)
        dq.drops.should eq drops.reverse
      end

      it 'drop time' do
        drops = Array.new(3) { |n| FactoryGirl.create(:drop, drop_time: DateTime.parse("2013-10-30 18:0#{n}")) }

        dq = DropsQuery.new(iSortCol_0: 5)
        dq.drops.should eq drops.reverse
      end

      it 'loot method' do
        loot_methods = %w{n g b}
        drops = Array.new(3) { |n| FactoryGirl.create(:drop, loot_method: loot_methods[n]) }

        dq = DropsQuery.new(iSortCol_0: 6)
        dq.drops.should eq drops.reverse
      end
    end
  end
end