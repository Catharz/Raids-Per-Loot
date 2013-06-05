require 'spec_helper'

describe NullCharacter do
  describe 'creating a character' do
    it 'defines a default name' do
      NullCharacter.new.name.should eq 'Unknown'
    end

    it 'allows setting the default name' do
      NullCharacter.new('Fred').name.should eq 'Fred'
    end
  end

  describe 'attributes' do
    describe 'main_character' do
      it 'creates a null raid main' do
        NullCharacter.new.main_character.should be_a NullCharacter
      end

      it 'allows setting the name' do
        NullCharacter.new.main_character('Barney').name.should eq 'Barney'
      end
    end

    describe 'raid_alternate' do
      it 'creates a null raid alternate' do
        NullCharacter.new.raid_alternate.should be_a NullCharacter
      end

      it 'allows setting the name' do
        NullCharacter.new.raid_alternate('Betty').name.should eq 'Betty'
      end
    end

    it 'creates an empty list of general alternates' do
      NullCharacter.new.general_alternates.should eq []
    end
  end
end