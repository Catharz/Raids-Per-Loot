require 'spec_helper'
include VersionsHelper

describe VersionsHelper do
  describe '#changes' do
    describe 'parameters' do
      it 'excludes the updated_at column by default' do
        char1 = FactoryGirl.create(:character)
        char2 = FactoryGirl.create(:character)

        changes(char1, char2).should eq [{key: "id", old: char1.id, new: char2.id},
                                         {key: "name", old: char1.name, new: char2.name},
                                         {key: "player_id", old: char1.player_id, new: char2.player_id},
                                         {key: "archetype_id", old: char1.archetype_id, new: char2.archetype_id},
                                         {key: "created_at", old: char1.created_at, new: char2.created_at}]
      end

      it 'excludes others columns when requested to' do
        char1 = FactoryGirl.create(:character)
        char2 = FactoryGirl.create(:character)

        excluded = Character.attribute_names - %w{name}
        changes(char1, char2, excluded).should eq [{key: "name", old: char1.name, new: char2.name}]
      end

      it 'includes the updated_at column if excluded columns is empty' do
        char1 = FactoryGirl.create(:character)
        char2 = FactoryGirl.create(:character)

        changes(char1, char2, []).should eq [{key: "id", old: char1.id, new: char2.id},
                                             {key: "name", old: char1.name, new: char2.name},
                                             {key: "player_id", old: char1.player_id, new: char2.player_id},
                                             {key: "archetype_id", old: char1.archetype_id, new: char2.archetype_id},
                                             {key: "created_at", old: char1.created_at, new: char2.created_at},
                                             {key: "updated_at", old: char1.updated_at, new: char2.updated_at}]
      end

      it 'only includes the changed columns' do
        char1 = FactoryGirl.create(:character)
        char2 = FactoryGirl.create(:character)

        changed_values = changes(char1, char2)
        changed_values.delete_if { |c| %w{id name player_id archetype_id created_at}.include? c[:key] }
        changed_values.should eq []
      end
    end

    context 'new items' do
      it 'includes all columns exception the updated_at column by default' do
        char2 = FactoryGirl.create(:character)

        changes(nil, char2).should eq [{key: "id", old: nil, new: char2.id},
                                       {key: "name", old: nil, new: char2.name},
                                       {key: "player_id", old: nil, new: char2.player_id},
                                       {key: "archetype_id", old: nil, new: char2.archetype_id},
                                       {key: "created_at", old: nil, new: char2.created_at},
                                       {key: "char_type", old: nil, new: char2.char_type},
                                       {key: "instances_count", old: nil, new: char2.instances_count},
                                       {key: "raids_count", old: nil, new: char2.raids_count},
                                       {key: "armour_rate", old: nil, new: char2.armour_rate},
                                       {key: "jewellery_rate", old: nil, new: char2.jewellery_rate},
                                       {key: "weapon_rate", old: nil, new: char2.weapon_rate},
                                       {key: "armour_count", old: nil, new: char2.armour_count},
                                       {key: "jewellery_count", old: nil, new: char2.jewellery_count},
                                       {key: "weapons_count", old: nil, new: char2.weapons_count},
                                       {key: "adornments_count", old: nil, new: char2.adornments_count},
                                       {key: "dislodgers_count", old: nil, new: char2.dislodgers_count},
                                       {key: "mounts_count", old: nil, new: char2.mounts_count},
                                       {key: "adornment_rate", old: nil, new: char2.adornment_rate},
                                       {key: "dislodger_rate", old: nil, new: char2.dislodger_rate},
                                       {key: "mount_rate", old: nil, new: char2.mount_rate},
                                       {key: "attuned_rate", old: nil, new: char2.attuned_rate},
                                       {key: "confirmed_rating", old: nil, new: char2.confirmed_rating},
                                       {key: "confirmed_date", old: nil, new: char2.confirmed_date}]
      end

      it 'excludes others columns when requested to' do
        char2 = FactoryGirl.create(:character)

        excluded = Character.attribute_names - %w{name}
        changes(nil, char2, excluded).should eq [{key: "name", old: nil, new: char2.name}]
      end

      it 'includes all columns if excluded columns is empty' do
        char2 = FactoryGirl.create(:character)

        changes(nil, char2, []).should eq [{key: "id", old: nil, new: char2.id},
                                           {key: "name", old: nil, new: char2.name},
                                           {key: "player_id", old: nil, new: char2.player_id},
                                           {key: "archetype_id", old: nil, new: char2.archetype_id},
                                           {key: "created_at", old: nil, new: char2.created_at},
                                           {key: "updated_at", old: nil, new: char2.updated_at},
                                           {key: "char_type", old: nil, new: char2.char_type},
                                           {key: "instances_count", old: nil, new: char2.instances_count},
                                           {key: "raids_count", old: nil, new: char2.raids_count},
                                           {key: "armour_rate", old: nil, new: char2.armour_rate},
                                           {key: "jewellery_rate", old: nil, new: char2.jewellery_rate},
                                           {key: "weapon_rate", old: nil, new: char2.weapon_rate},
                                           {key: "armour_count", old: nil, new: char2.armour_count},
                                           {key: "jewellery_count", old: nil, new: char2.jewellery_count},
                                           {key: "weapons_count", old: nil, new: char2.weapons_count},
                                           {key: "adornments_count", old: nil, new: char2.adornments_count},
                                           {key: "dislodgers_count", old: nil, new: char2.dislodgers_count},
                                           {key: "mounts_count", old: nil, new: char2.mounts_count},
                                           {key: "adornment_rate", old: nil, new: char2.adornment_rate},
                                           {key: "dislodger_rate", old: nil, new: char2.dislodger_rate},
                                           {key: "mount_rate", old: nil, new: char2.mount_rate},
                                           {key: "attuned_rate", old: nil, new: char2.attuned_rate},
                                           {key: "confirmed_rating", old: nil, new: char2.confirmed_rating},
                                           {key: "confirmed_date", old: nil, new: char2.confirmed_date}]
      end
    end
  end
end
