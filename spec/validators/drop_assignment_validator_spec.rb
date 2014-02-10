require 'spec_helper'

describe DropAssignmentValidator do
  let(:armour) { mock_model(LootType, name: 'Armour', default_loot_method: 'n') }
  let(:weapon) { mock_model(LootType, name: 'Weapon', default_loot_method: 'n') }
  let(:trade_skill) { mock_model(LootType, name: 'Trade Skill', default_loot_method: 'g') }
  let(:spell) { mock_model(LootType, name: 'Spell', default_loot_method: 'g') }
  let(:trash) { mock_model(LootType, name: 'Trash', default_loot_method: 't') }

  let(:fighter) { mock_model(Archetype, name: 'Fighter') }
  let(:scout) { mock_model(Archetype, name: 'Scout') }
  let(:priest) { mock_model(Player, name: 'Fred') }

  let(:player) { mock_model(Player, name: 'Fred') }
  let(:raid_main) { mock_model(Character, name: 'Barny', player: player, char_type: 'm', archetype: fighter) }
  let(:raid_alternate) { mock_model(Character, name: 'Betty', player: player, char_type: 'r', archetype: scout) }
  let(:general_alternate) { mock_model(Character, name: 'Wilma', player: player, char_type: 'g', archetype: priest) }

  describe '#validate' do
    context 'when character is nil' do
      it 'signifies an issue' do
        item = mock_model(Item, loot_type: armour)
        drop = Drop.new(character: nil, item: item, loot_method: 'n', loot_type: armour)

        DropAssignmentValidator.new(drop).validate.
            should include 'No Character for Drop'
      end
    end

    context 'when drop and item loot type do not match' do
      it 'signifies an issue' do
        item = mock_model(Item, loot_type: armour)
        drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: weapon)

        DropAssignmentValidator.new(drop).validate.should eql ['Drop / Item Type Mismatch']
      end
    end

    context 'when looting a normal item' do
      context 'via need' do
        it 'signifies no issues' do
          item = mock_model(Item, loot_type: armour)
          drop = Drop.new(character: raid_main, item: item,
                          loot_method: 'n', loot_type: armour)

          DropAssignmentValidator.new(drop).validate.should eql []
        end
      end

      context 'via random' do
        it 'signifies no issue' do
          item = mock_model(Item, loot_type: armour)
          drop = Drop.new(character: raid_main, item: item,
                          loot_method: 'r', loot_type: armour)

          DropAssignmentValidator.new(drop).validate.should eql []
        end
      end

      context 'via bid' do
        it 'signifies no issue' do
          item = mock_model(Item, loot_type: armour)
          drop = Drop.new(character: raid_main, item: item,
                          loot_method: 'b', loot_type: armour)

          DropAssignmentValidator.new(drop).validate.should eql []
        end
      end

      context 'via guild bank' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: armour)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'g',
                          loot_type: armour)

          DropAssignmentValidator.new(drop).validate.
              should eql ['Loot via Guild Bank for non-Guild Bank Item']
        end
      end

      context 'via trash' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: armour)
          drop = Drop.new(character: raid_main, item: item, loot_method: 't',
                          loot_type: armour)

          DropAssignmentValidator.new(drop).validate.
              should eql ['Loot via Trash for Non-Trash item']
        end
      end
    end

    context 'when looting a trade skill item' do
      context 'via need' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: trade_skill)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'n',
                          loot_type: trade_skill)

          DropAssignmentValidator.new(drop).validate.
              should include 'Loot via Need for Guild Bank Item'
        end
      end
      context 'via random' do
        it 'signifies no issues' do
          item = mock_model(Item, loot_type: trade_skill)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'r',
                          loot_type: trade_skill)

          DropAssignmentValidator.new(drop).validate.should eql []
        end
      end
      context 'via guild bank' do
        it 'signifies no issues' do
          item = mock_model(Item, loot_type: trade_skill)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'g',
                          loot_type: trade_skill)

          DropAssignmentValidator.new(drop).validate.should eql []
        end
      end
      context 'via trash' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: trade_skill)
          drop = Drop.new(character: raid_main, item: item, loot_method: 't',
                          loot_type: trade_skill)

          DropAssignmentValidator.new(drop).validate.
              should eql ['Loot via Trash for Non-Trash item']
        end
      end
    end

    context 'when looting a spell' do
      context 'via need' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: spell)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'n',
                          loot_type: spell)

          DropAssignmentValidator.new(drop).validate.
              should eql ['Loot via Need for Guild Bank Item']
        end
      end
      context 'via random' do
        it 'signifies no issues' do
          item = mock_model(Item, loot_type: spell)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'r',
                          loot_type: spell)

          DropAssignmentValidator.new(drop).validate.should eql []
        end
      end
      context 'via guild bank' do
        it 'signifies no issues' do
          item = mock_model(Item, loot_type: spell)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'g',
                          loot_type: spell)

          DropAssignmentValidator.new(drop).validate.should eql []
        end
      end
      context 'via trash' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: spell)
          drop = Drop.new(character: raid_main, item: item, loot_method: 't',
                          loot_type: spell)

          DropAssignmentValidator.new(drop).validate.
              should eql ['Loot via Trash for Non-Trash item']
        end
      end
    end

    context 'when looting a trash item' do
      context 'via need' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: trash)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'n',
                          loot_type: trash)

          DropAssignmentValidator.new(drop).validate.
              should eql ['Loot via Need for Trash Item']
        end
      end
      context 'via random' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: trash)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'r',
                          loot_type: trash)

          DropAssignmentValidator.new(drop).validate.
              should include 'Loot via Random on Trash Item'
        end
      end
      context 'via bid' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: trash)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'b',
                          loot_type: trash)

          DropAssignmentValidator.new(drop).validate.
              should include'Loot via Bid on Trash Item'
        end
      end
      context 'via guild bank' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: trash)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'g',
                          loot_type: trash)

          DropAssignmentValidator.new(drop).validate.
              should eql ['Loot via Guild Bank for non-Guild Bank Item']
        end
      end
      context 'via trash' do
        it 'signifies no issues' do
          item = mock_model(Item, loot_type: trash)
          drop = Drop.new(character: raid_main, item: item, loot_method: 't',
                          loot_type: trash)

          DropAssignmentValidator.new(drop).validate.should eql []
        end
      end
    end
  end
end
