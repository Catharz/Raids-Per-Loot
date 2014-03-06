require 'spec_helper'
include VersionsHelper

describe VersionsHelper do
  describe '#changes' do
    it 'returns an empty array for unknown event types' do
      version = FactoryGirl.create(:version, event: 'party!')
      expect(changes(version)).to eq []
    end

    context 'updates' do
      it 'excludes the updated_at column by default' do
        char1 = FactoryGirl.create(:character)
        char2 = FactoryGirl.create(:character)
        version = FactoryGirl.create(:version,
                                     item_id: char2.id,
                                     item_type: 'Character',
                                     event: 'update',
                                     object: char1.to_yaml)
        version.stub(:previous_version).and_return(char1)

        expect(changes(version)).to \
          match_array [{key: 'id', old: char1.id, new: char2.id},
                       {key: 'name', old: char1.name, new: char2.name},
                       {key: 'player_id', old: char1.player_id, new: char2.player_id},
                       {key: 'archetype_id', old: char1.archetype_id, new: char2.archetype_id},
                       {key: 'created_at', old: char1.created_at, new: char2.created_at}]
      end

      it 'excludes other columns when requested' do
        char1 = FactoryGirl.create(:character)
        char2 = FactoryGirl.create(:character)
        version = FactoryGirl.create(:version,
                                     item_id: char2.id,
                                     item_type: 'Character',
                                     event: 'update',
                                     object: char1.to_yaml)
        version.stub(:previous_version).and_return(char1)

        excluded = Character.attribute_names - %w{name}
        expect(changes(version, excluded)).to eq [{key: 'name', old: char1.name, new: char2.name}]
      end

      it 'only includes the changed columns' do
        char1 = FactoryGirl.create(:character)
        char2 = FactoryGirl.create(:character)
        version = FactoryGirl.create(:version,
                                     item_id: char2.id,
                                     item_type: 'Character',
                                     event: 'update',
                                     object: char1.to_yaml)
        version.stub(:previous_version).and_return(char1)

        changed_values = changes(version)
        changed_values.
            delete_if { |c| %w{id name player_id archetype_id created_at}.
            include? c[:key] }
        expect(changed_values).to eq []
      end
    end

    context 'creates' do
      it 'excludes the updated_at column by default' do
        char2 = FactoryGirl.create(:character)
        version = FactoryGirl.create(:version,
                                     item_id: char2.id,
                                     item_type: 'Character',
                                     event: 'create',
                                     object: nil)

        expect(changes(version)).to \
          match_array [{key: 'id', old: nil, new: char2.id},
                       {key: 'name', old: nil, new: char2.name},
                       {key: 'player_id', old: nil, new: char2.player_id},
                       {key: 'archetype_id', old: nil, new: char2.archetype_id},
                       {key: 'created_at', old: nil, new: char2.created_at},
                       {key: 'char_type', old: nil, new: char2.char_type},
                       {key: 'instances_count', old: nil, new: char2.instances_count},
                       {key: 'raids_count', old: nil, new: char2.raids_count},
                       {key: 'armour_rate', old: nil, new: char2.armour_rate},
                       {key: 'jewellery_rate', old: nil, new: char2.jewellery_rate},
                       {key: 'weapon_rate', old: nil, new: char2.weapon_rate},
                       {key: 'armour_count', old: nil, new: char2.armour_count},
                       {key: 'jewellery_count', old: nil, new: char2.jewellery_count},
                       {key: 'weapons_count', old: nil, new: char2.weapons_count},
                       {key: 'adornments_count', old: nil, new: char2.adornments_count},
                       {key: 'dislodgers_count', old: nil, new: char2.dislodgers_count},
                       {key: 'mounts_count', old: nil, new: char2.mounts_count},
                       {key: 'adornment_rate', old: nil, new: char2.adornment_rate},
                       {key: 'dislodger_rate', old: nil, new: char2.dislodger_rate},
                       {key: 'mount_rate', old: nil, new: char2.mount_rate},
                       {key: 'attuned_rate', old: nil, new: char2.attuned_rate},
                       {key: 'confirmed_rating', old: nil, new: char2.confirmed_rating},
                       {key: 'confirmed_date', old: nil, new: char2.confirmed_date}]
      end

      it 'excludes others columns when requested to' do
        char2 = FactoryGirl.create(:character)
        version = FactoryGirl.create(:version,
                                     item_id: char2.id,
                                     item_type: 'Character',
                                     event: 'create',
                                     object: nil)

        excluded = Character.attribute_names - %w{name}
        expect(changes(version, excluded)).to eq [{key: 'name', old: nil, new: char2.name}]
      end

      it 'includes all columns if excluded columns is empty' do
        char2 = FactoryGirl.create(:character)
        version = FactoryGirl.create(:version,
                                     item_id: char2.id,
                                     item_type: 'Character',
                                     event: 'create',
                                     object: nil)

        expect(changes(version, [])).to \
          match_array [{key: 'id', old: nil, new: char2.id},
                       {key: 'name', old: nil, new: char2.name},
                       {key: 'player_id', old: nil, new: char2.player_id},
                       {key: 'archetype_id', old: nil, new: char2.archetype_id},
                       {key: 'created_at', old: nil, new: char2.created_at},
                       {key: 'updated_at', old: nil, new: char2.updated_at},
                       {key: 'char_type', old: nil, new: char2.char_type},
                       {key: 'instances_count', old: nil, new: char2.instances_count},
                       {key: 'raids_count', old: nil, new: char2.raids_count},
                       {key: 'armour_rate', old: nil, new: char2.armour_rate},
                       {key: 'jewellery_rate', old: nil, new: char2.jewellery_rate},
                       {key: 'weapon_rate', old: nil, new: char2.weapon_rate},
                       {key: 'armour_count', old: nil, new: char2.armour_count},
                       {key: 'jewellery_count', old: nil, new: char2.jewellery_count},
                       {key: 'weapons_count', old: nil, new: char2.weapons_count},
                       {key: 'adornments_count', old: nil, new: char2.adornments_count},
                       {key: 'dislodgers_count', old: nil, new: char2.dislodgers_count},
                       {key: 'mounts_count', old: nil, new: char2.mounts_count},
                       {key: 'adornment_rate', old: nil, new: char2.adornment_rate},
                       {key: 'dislodger_rate', old: nil, new: char2.dislodger_rate},
                       {key: 'mount_rate', old: nil, new: char2.mount_rate},
                       {key: 'attuned_rate', old: nil, new: char2.attuned_rate},
                       {key: 'confirmed_rating', old: nil, new: char2.confirmed_rating},
                       {key: 'confirmed_date', old: nil, new: char2.confirmed_date}]
      end
    end

    context 'deletes' do
      it 'excludes the updated_at column by default' do
        char1 = FactoryGirl.create(:character, confirmed_rating: 'optimal',
                                   confirmed_date: Date.today)
        version = FactoryGirl.create(:version,
                                     item_id: char1.id,
                                     item_type: 'Character',
                                     event: 'destroy',
                                     object: char1.to_yaml)
        version.stub(:reify).and_return(char1)

        expect(changes(version)).to \
          match_array [{key: 'id', old: char1.id, new: nil},
                       {key: 'name', old: char1.name, new: nil},
                       {key: 'player_id', old: char1.player_id, new: nil},
                       {key: 'archetype_id', old: char1.archetype_id, new: nil},
                       {key: 'created_at', old: char1.created_at, new: nil},
                       {key: 'char_type', old: char1.char_type, new: nil},
                       {key: 'instances_count', old: char1.instances_count, new: nil},
                       {key: 'raids_count', old: char1.raids_count, new: nil},
                       {key: 'armour_rate', old: char1.armour_rate, new: nil},
                       {key: 'jewellery_rate', old: char1.jewellery_rate, new: nil},
                       {key: 'weapon_rate', old: char1.weapon_rate, new: nil},
                       {key: 'armour_count', old: char1.armour_count, new: nil},
                       {key: 'jewellery_count', old: char1.jewellery_count, new: nil},
                       {key: 'weapons_count', old: char1.weapons_count, new: nil},
                       {key: 'adornments_count', old: char1.adornments_count, new: nil},
                       {key: 'dislodgers_count', old: char1.dislodgers_count, new: nil},
                       {key: 'mounts_count', old: char1.mounts_count, new: nil},
                       {key: 'adornment_rate', old: char1.adornment_rate, new: nil},
                       {key: 'dislodger_rate', old: char1.dislodger_rate, new: nil},
                       {key: 'mount_rate', old: char1.mount_rate, new: nil},
                       {key: 'attuned_rate', old: char1.attuned_rate, new: nil},
                       {key: 'confirmed_rating', old: char1.confirmed_rating, new: nil},
                       {key: 'confirmed_date', old: char1.confirmed_date, new: nil}]
      end

      it 'excludes others columns when requested to' do
        char1 = FactoryGirl.create(:character, confirmed_rating: 'optimal',
                                   confirmed_date: Date.today)
        version = FactoryGirl.create(:version,
                                     item_id: char1.id,
                                     item_type: 'Character',
                                     event: 'destroy',
                                     object: char1.to_yaml)
        version.stub(:reify).and_return(char1)

        excluded = Character.attribute_names - %w{name}
        expect(changes(version, excluded)).
            to eq [{key: 'name', old: char1.name, new: nil}]
      end

      it 'includes all columns if excluded columns is empty' do
        char1 = FactoryGirl.create(:character, confirmed_rating: 'optimal',
                                   confirmed_date: Date.today)
        version = FactoryGirl.create(:version,
                                     item_id: char1.id,
                                     item_type: 'Character',
                                     event: 'destroy',
                                     object: char1.to_yaml)
        version.stub(:reify).and_return(char1)

        expect(changes(version, [])).to \
          match_array [{key: 'id', old: char1.id, new: nil},
                       {key: 'name', old: char1.name, new: nil},
                       {key: 'player_id', old: char1.player_id, new: nil},
                       {key: 'archetype_id', old: char1.archetype_id, new: nil},
                       {key: 'created_at', old: char1.created_at, new: nil},
                       {key: 'updated_at', old: char1.updated_at, new: nil},
                       {key: 'char_type', old: char1.char_type, new: nil},
                       {key: 'instances_count', old: char1.instances_count, new: nil},
                       {key: 'raids_count', old: char1.raids_count, new: nil},
                       {key: 'armour_rate', old: char1.armour_rate, new: nil},
                       {key: 'jewellery_rate', old: char1.jewellery_rate, new: nil},
                       {key: 'weapon_rate', old: char1.weapon_rate, new: nil},
                       {key: 'armour_count', old: char1.armour_count, new: nil},
                       {key: 'jewellery_count', old: char1.jewellery_count, new: nil},
                       {key: 'weapons_count', old: char1.weapons_count, new: nil},
                       {key: 'adornments_count', old: char1.adornments_count, new: nil},
                       {key: 'dislodgers_count', old: char1.dislodgers_count, new: nil},
                       {key: 'mounts_count', old: char1.mounts_count, new: nil},
                       {key: 'adornment_rate', old: char1.adornment_rate, new: nil},
                       {key: 'dislodger_rate', old: char1.dislodger_rate, new: nil},
                       {key: 'mount_rate', old: char1.mount_rate, new: nil},
                       {key: 'attuned_rate', old: char1.attuned_rate, new: nil},
                       {key: 'confirmed_rating', old: char1.confirmed_rating, new: nil},
                       {key: 'confirmed_date', old: char1.confirmed_date, new: nil}]
      end
    end
  end
end
