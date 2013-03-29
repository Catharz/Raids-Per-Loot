require 'spec_helper'

describe CharacterType do
  context 'associations' do
    it { should belong_to(:character) }
    it { should delegate_method(:player_name).to(:character) }
  end

  context 'validations' do
    it { should validate_presence_of(:character_id) }
    it { should validate_presence_of(:char_type) }
    it { should validate_presence_of(:effective_date) }

    it { should allow_value('g').for(:char_type) }
    it { should allow_value('m').for(:char_type) }
    it { should allow_value('r').for(:char_type) }
  end

  context 'instance methods' do
    describe '#character_name' do
      it 'returns Unknown if the character is nil' do
        character_type = CharacterType.new

        character_type.character_name.should eq('Unknown')
      end
    end
  end
end