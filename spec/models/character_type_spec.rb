require 'spec_helper'

describe CharacterType do
  context 'validations' do
    it { should validate_presence_of(:character) }
    it { should validate_presence_of(:char_type) }
    it { should validate_presence_of(:effective_date) }

    it { should allow_value('g').for(:char_type) }
    it { should allow_value('m').for(:char_type) }
    it { should allow_value('r').for(:char_type) }
  end

  context 'associations' do
    it { should belong_to(:character) }

    it 'is created for a new character' do
      char1 = FactoryGirl.create(:character)
      CharacterObserver.instance.after_create(char1)

      char_types = CharacterType.all
      char_types.should eq char1.character_types
      char_types.count.should eq 1
    end
  end

  context 'instance methods' do
    describe 'character_type_name' do
      it 'returns "Raid Main" for "m"' do
        ct = FactoryGirl.create(:character_type, char_type: 'm')

        ct.character_type_name.should eq 'Raid Main'
      end

      it 'returns "Raid Alternate" for "r"' do
        ct = FactoryGirl.create(:character_type, char_type: 'r')

        ct.character_type_name.should eq 'Raid Alternate'
      end

      it 'returns "General Alternate" for "g"' do
        ct = FactoryGirl.create(:character_type, char_type: 'g')

        ct.character_type_name.should eq 'General Alternate'
      end
    end

    describe 'character_first_raid_date' do
      it 'returns nil when the character has not raided' do
        character = FactoryGirl.create(:character)
        ct = FactoryGirl.create(:character_type, character_id: character.id)

        character.should_receive(:first_raid).and_return(nil)
        ct.should_receive(:character).and_return(character)

        ct.character_first_raid_date.should be_nil
      end

      it 'returns the date of the first raid if they have raided' do
        character = FactoryGirl.create(:character)
        raid = FactoryGirl.create(:raid)
        ct = FactoryGirl.create(:character_type, character_id: character.id)

        character.should_receive(:first_raid).twice.and_return(raid)
        ct.should_receive(:character).twice.and_return(character)

        ct.character_first_raid_date.should eq raid.raid_date
      end
    end

    describe 'character_last_raid_date' do
      it 'returns nil when the character has not raided' do
        character = FactoryGirl.create(:character)
        ct = FactoryGirl.create(:character_type, character_id: character.id)

        character.should_receive(:last_raid).and_return nil
        ct.should_receive(:character).and_return(character)

        ct.character_last_raid_date.should be_nil
      end

      it 'returns the date of the last raid if they have raided' do
        character = FactoryGirl.create(:character)
        raid = FactoryGirl.create(:raid)
        ct = FactoryGirl.create(:character_type, character_id: character.id)

        character.should_receive(:last_raid).twice.and_return(raid)
        ct.should_receive(:character).twice.and_return(character)

        ct.character_last_raid_date.should eq raid.raid_date
      end
    end
  end

  context 'scopes' do
    describe 'none' do
      it 'returns an empty list' do
        FactoryGirl.create(:character_type)

        CharacterType.none.should eq []
      end
    end

    describe 'by_character' do
      before(:each) do
        @char1 = FactoryGirl.create(:character)
        @char2 = FactoryGirl.create(:character)
        @ct1 = FactoryGirl.create(:character_type, character_id: @char1.id)
        @ct2 = FactoryGirl.create(:character_type, character_id: @char2.id)
      end

      it 'shows all by default' do
        CharacterType.by_character.should match_array [@char1.character_types, @char2.character_types].flatten
      end

      it 'filters by character_id' do
        CharacterType.by_character(@ct1.character_id).should match_array @char1.character_types
      end
    end

    describe 'as_at' do
      before(:each) do
        @ct1 = FactoryGirl.create(:character_type, effective_date: 3.months.ago)
        @ct2 = FactoryGirl.create(:character_type, effective_date: 1.week.ago)
      end

      it 'shows none by default' do
        CharacterType.as_at.should eq []
      end

      it 'gives the last one as of a specified date' do
        CharacterType.as_at(1.month.ago).should eq [@ct1]
      end
    end

    describe 'by_character_and_date' do
      it 'reuses by_character and as_at' do
        character = mock(Character)
        date = 3.weeks.ago
        CharacterType.should_receive(:by_character).with(character).and_return(CharacterType.scoped)
        CharacterType.should_receive(:as_at).with(date)

        CharacterType.by_character_and_date(character, date)
      end
    end
  end
end