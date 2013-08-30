require 'spec_helper'

describe PlayerCharacter do
  fixtures :ranks, :archetypes, :services, :users
  let(:player1) { FactoryGirl.create(:player, raids_count: 10) }
  let(:player2) { FactoryGirl.create(:player, raids_count: 20) }
  let(:char1) { FactoryGirl.create(:character, player: player2, char_type: 'm',
                                   armour_count: 6, jewellery_count: 7,
                                   weapons_count: 8, adornments_count: 1,
                                   dislodgers_count: 2, mounts_count: 3) }
  let(:char2) { FactoryGirl.create(:character, player: player1, char_type: 'm',
                                   armour_count: 5, jewellery_count: 6,
                                   weapons_count: 7, adornments_count: 2,
                                   dislodgers_count: 3, mounts_count: 4) }
  let(:char3) { FactoryGirl.create(:character, player: player2, char_type: 'r',
                                   armour_count: 4, jewellery_count: 5,
                                   weapons_count: 6, adornments_count: 3,
                                   dislodgers_count: 4, mounts_count: 5) }
  let(:char4) { FactoryGirl.create(:character, player: player1, char_type: 'r',
                                   armour_count: 3, jewellery_count: 4,
                                   weapons_count: 5, adornments_count: 4,
                                   dislodgers_count: 5, mounts_count: 6) }
  let(:char5) { FactoryGirl.create(:character, player: player2, char_type: 'g',
                                   armour_count: 2, jewellery_count: 3,
                                   weapons_count: 4, adornments_count: 5,
                                   dislodgers_count: 6, mounts_count: 7) }
  let(:char6) { FactoryGirl.create(:character, player: player1, char_type: 'g',
                                   armour_count: 1, jewellery_count: 2,
                                   weapons_count: 3, adornments_count: 6,
                                   dislodgers_count: 7, mounts_count: 8) }

  describe 'class methods' do
    describe '#new' do
      it 'assigns the character' do
        characters = Character.all

        characters.collect do |character|
          PlayerCharacter.new(character.id).character.should eq character
        end
      end

      it 'assigns the player' do
        characters = Character.all

        characters.collect do |character|
          PlayerCharacter.new(character.id).player.should eq character.player
        end
      end
    end
  end

  describe 'instance methods' do
    describe 'reload' do
      it 'calls reload on the character' do
        pc = PlayerCharacter.new(char1.id)
        pc.character.should_receive(:reload)
        pc.reload
      end

      it 'calls reload on the player' do
        pc = PlayerCharacter.new(char2.id)
        pc.player.should_receive(:reload)
        pc.reload
      end
    end

    describe '#persisted?' do
      it 'always returns false' do
        pc = PlayerCharacter.new(char4.id)
        pc.persisted?.should be_false
      end
    end

    describe '#save' do
      it 'always returns true' do
        pc = PlayerCharacter.new(char5.id)
        pc.save.should be_true
      end
    end
  end
end