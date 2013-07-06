require 'spec_helper'
require 'character_spec_helper'

describe CharacterObserver do
  include CharacterSpecHelper
  subject { CharacterObserver.instance }

  before(:each) do
    @character = FactoryGirl.create(:character, char_type: 'm')
    @character_type = FactoryGirl.create(:character_type, character: @character, char_type: 'm')
    @character.should_receive(:last_switch).at_least(0).times.and_return(@character_type)
    Resque.should_receive(:enqueue).at_least(1).times.with(SonyCharacterUpdater, @character.id)
  end

  describe 'after_create' do
    it 'stores a character_type for new characters' do
      subject.should_receive(:save_new_char_type).with(@character)

      subject.after_create(@character)
    end
  end

  describe 'after_save' do
    it 'stores an updated character_type when the char_type changes' do
      subject.should_receive(:save_new_char_type).with(@character)
      @character.char_type = 'r'

      subject.after_save(@character)
    end

    it "doesn't store an updated character_type when the char_type doesn't change" do
      subject.should_not_receive(:save_new_char_type)

      subject.after_save(@character)
    end
  end
end