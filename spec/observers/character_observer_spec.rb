require 'spec_helper'
require 'character_spec_helper'

describe CharacterObserver do
  include CharacterSpecHelper

  describe 'after_create' do
    before do
      @character = nil
      @creating_character = lambda do
        @character = Character.create(valid_character_attributes(:name => "char 1", :char_type => 'm'))
        violated "#{@character.errors.full_messages.to_sentence}" if @character.new_record?
      end
    end

    it "stores a character_type for new characters" do
      @creating_character.should change(CharacterType, :count).by(1)
    end
  end

  describe 'after_save' do
    before do
      @character = Character.create(valid_character_attributes(:name => "char 2", :char_type => 'm'))
      @changing_char_type = lambda do
        @character.char_type = 'r'
        @character.save
        violated "#{@character.errors.full_messages.to_sentence}" unless @character.valid?
      end
    end

    it "stores an updated character_type when the char_type changes" do
      @changing_char_type.should change(CharacterType, :count).by(1)
      @character.reload
      @character.last_switch.should_not be_nil
      @character.last_switch.char_type.should == 'r'
    end
  end
end