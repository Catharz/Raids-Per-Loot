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

        expect(changes(version).select { |a| a[:key] == 'updated_at' } ).to be_empty
        expect(changes(version).select { |a| a[:key] == 'name' } ).to \
          eq [{key: 'name', old: char1.name, new: char2.name}]
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

        expect(changes(version).select { |a| a[:key] == 'updated_at' } ).to be_empty
        expect(changes(version).select { |a| a[:key] == 'name' } ).to \
          eq [{key: 'name', old: nil, new: char2.name}]
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

        expect(changes(version, []).count).to eq Character.attribute_names.count
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

        expect(changes(version).select { |a| a[:key] == 'updated_at' } ).to be_empty
        expect(changes(version).select { |a| a[:key] == 'name' } ).to \
          eq [{key: 'name', old: char1.name, new: nil}]
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

        expect(changes(version, []).count).to eq Character.attribute_names.count
      end
    end
  end
end
