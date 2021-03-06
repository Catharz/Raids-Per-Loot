require 'spec_helper'

describe CharacterObserver do
  subject { CharacterObserver.instance }

  before(:each) do
    @character = FactoryGirl.create(:character, char_type: 'm')
    @character_type = FactoryGirl.create(:character_type,
                                         character: @character, char_type: 'm')
    @character.stub(:last_switch).and_return(@character_type)
    Resque.should_receive(:enqueue).at_least(1).times.
        with(SonyCharacterUpdater, @character.id)
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

    it "doesn't try to store character_type when it hasn't changed" do
      subject.should_not_receive(:save_new_char_type)

      subject.after_save(@character)
    end
  end
end