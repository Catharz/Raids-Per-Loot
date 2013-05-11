require 'spec_helper'

describe CharacterType do
  context 'validations' do
    it { should validate_presence_of(:character_id) }
    it { should validate_presence_of(:char_type) }
    it { should validate_presence_of(:effective_date) }

    it { should allow_value('g').for(:char_type) }
    it { should allow_value('m').for(:char_type) }
    it { should allow_value('r').for(:char_type) }
  end
end