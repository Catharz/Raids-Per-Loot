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
        item.should_receive(:archetypes).and_return([fighter, scout])
        drop = Drop.new(character: nil, item: item, loot_method: 'n', loot_type: armour)

        DropAssignmentValidator.new(drop).validate.
            should include 'No Character for Drop'
      end
    end

    context 'when drop and item loot type do not match' do
      it 'signifies an issue' do
        item = mock_model(Item, loot_type: armour)
        item.should_receive(:archetypes).twice.and_return([fighter, scout])
        drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: weapon)
        raid_main.should_receive(:general_alternates).and_return([general_alternate])

        DropAssignmentValidator.new(drop).validate.should eql ['Drop / Item Type Mismatch']
      end
    end

    context 'when looting a normal item' do
      context 'via need' do
        context 'for a raid main' do
          context 'of the right archetype' do
            it 'signifies no issues' do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).twice.
                  and_return([fighter, scout])
              drop = Drop.new(character: raid_main, item: item,
                              loot_method: 'n', loot_type: armour)
              raid_main.should_receive(:general_alternates).
                  and_return([general_alternate])

              DropAssignmentValidator.new(drop).validate.should eql []
            end
          end
          context 'of the wrong archetype' do
            it 'signifies an issue' do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).twice.and_return([priest])
              drop = Drop.new(character: raid_main, item: item,
                              loot_method: 'n', loot_type: armour)
              raid_main.should_receive(:general_alternates).
                  and_return([general_alternate])

              DropAssignmentValidator.new(drop).validate.
                  should eql ['Item / Character Class Mis-Match']
            end
          end
        end
        context 'for a raid alternate' do
          it 'signifies no issues' do
            item = mock_model(Item, loot_type: armour)
            item.should_receive(:archetypes).twice.and_return([fighter, scout])
            drop = Drop.new(character: raid_alternate, item: item,
                            loot_method: 'n', loot_type: armour)
            raid_alternate.should_receive(:general_alternates).
                and_return([general_alternate])

            DropAssignmentValidator.new(drop).validate.should eql []
          end
        end
        context 'for a general alternate' do
          it 'signifies an issue' do
            item = mock_model(Item, loot_type: armour)
            item.should_receive(:archetypes).twice.and_return([fighter, scout])
            drop = Drop.new(character: general_alternate, item: item,
                            loot_method: 'n', loot_type: armour)
            general_alternate.should_receive(:general_alternates).
                and_return([general_alternate])

            DropAssignmentValidator.new(drop).validate.
                should include 'Loot via Need for General Alternate'
          end
        end
      end

      context 'via random' do
        context 'for a raid main' do
          it 'signifies an issue' do
            item = mock_model(Item, loot_type: armour)
            drop = Drop.new(character: raid_main, item: item,
                            loot_method: 'r', loot_type: armour)
            raid_main.should_receive(:raid_alternate).
                and_return(raid_alternate)

            DropAssignmentValidator.new(drop).validate.
                should eql ['Loot via Random for Non-Raid Alt']
          end
        end
        context 'for a raid alternate' do
          context 'of the right archetype' do
            it 'signifies no issues' do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).twice.
                  and_return([fighter,scout])
              drop = Drop.new(character: raid_alternate, item: item,
                              loot_method: 'r', loot_type: armour)
              raid_alternate.should_receive(:raid_alternate).
                  and_return(raid_alternate)

              DropAssignmentValidator.new(drop).validate.should eql []
            end
          end
          context 'of the wrong archetype' do
            it 'signifies an issue' do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).twice.and_return([priest])
              drop = Drop.new(character: raid_alternate, item: item,
                              loot_method: 'r', loot_type: armour)
              raid_alternate.should_receive(:raid_alternate).
                  and_return(raid_alternate)

              DropAssignmentValidator.new(drop).validate.
                  should eql ['Item / Character Class Mis-Match']
            end
          end
        end
        context 'for a general alternate' do
          it 'signifies an issue' do
            item = mock_model(Item, loot_type: armour)
            drop = Drop.new(character: general_alternate, item: item,
                            loot_method: 'r', loot_type: armour)
            general_alternate.should_receive(:raid_alternate).
                and_return(raid_alternate)

            DropAssignmentValidator.new(drop).validate.
                should eql ['Loot via Random for Non-Raid Alt']
          end
        end
      end

      context 'via bid' do
        context 'for raid main' do
          it 'signifies an issue' do
            item = mock_model(Item, loot_type: armour)
            drop = Drop.new(character: raid_main, item: item, loot_method: 'b',
                            loot_type: armour)
            raid_main.should_receive(:main_character).and_return(raid_main)

            DropAssignmentValidator.new(drop).validate.
                should eql ['Loot via Bid for Raid Main']
          end
        end
        context 'for raid alt' do
          it 'signifies an issue' do
            item = mock_model(Item, loot_type: armour)
            drop = Drop.new(character: raid_alternate, item: item,
                            loot_method: 'b', loot_type: armour)
            raid_alternate.should_receive(:main_character).and_return(raid_main)
            raid_alternate.should_receive(:raid_alternate).
                and_return(raid_alternate)

            DropAssignmentValidator.new(drop).validate.
                should eql ['Loot via Bid for Raid Alt']
          end
        end
        context 'for general alt' do
          context 'of the right archetype' do
            it 'signifies no issues' do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).and_return([priest])
              drop = Drop.new(character: general_alternate, item: item,
                              loot_method: 'b', loot_type: armour)
              general_alternate.should_receive(:main_character).
                  and_return(raid_main)
              general_alternate.should_receive(:raid_alternate).
                  and_return(raid_alternate)

              DropAssignmentValidator.new(drop).validate.should eql []
            end
          end
          context 'of the wrong archetype' do
            it 'signifies an issue' do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).and_return([fighter, scout])
              drop = Drop.new(character: general_alternate, item: item,
                              loot_method: 'b', loot_type: armour)
              general_alternate.should_receive(:main_character).
                  and_return(raid_main)
              general_alternate.should_receive(:raid_alternate).
                  and_return(raid_alternate)

              DropAssignmentValidator.new(drop).validate.
                  should eql ['Item / Character Class Mis-Match']
            end
          end
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
          item.should_receive(:archetypes).at_least(2).times.
              and_return([priest])
          drop = Drop.new(character: raid_main, item: item, loot_method: 'n',
                          loot_type: trade_skill)
          raid_main.should_receive(:general_alternates).
              and_return([general_alternate])

          DropAssignmentValidator.new(drop).validate.
              should include 'Loot via Need for Guild Bank Item'
        end
      end
      context 'via random' do
        it 'signifies no issues' do
          item = mock_model(Item, loot_type: trade_skill)
          item.should_receive(:archetypes).and_return([])
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
          item.should_receive(:archetypes).at_least(2).times.
              and_return([fighter])
          drop = Drop.new(character: raid_main, item: item, loot_method: 'n',
                          loot_type: spell)
          raid_main.should_receive(:general_alternates).
              and_return([general_alternate])

          DropAssignmentValidator.new(drop).validate.
              should eql ['Loot via Need for Guild Bank Item']
        end
      end
      context 'via random' do
        context 'for the right archetype' do
          it 'signifies no issues' do
            item = mock_model(Item, loot_type: spell)
            item.should_receive(:archetypes).at_least(2).times.
                and_return([fighter])
            drop = Drop.new(character: raid_main, item: item, loot_method: 'r',
                            loot_type: spell)

            DropAssignmentValidator.new(drop).validate.should eql []
          end
        end
        context 'for the wrong archetype' do
          it 'signifies an issue' do
            item = mock_model(Item, loot_type: spell)
            item.should_receive(:archetypes).at_least(2).times.
                and_return([priest])
            drop = Drop.new(character: raid_main, item: item, loot_method: 'r',
                            loot_type: spell)

            DropAssignmentValidator.new(drop).validate.
                should eql ['Item / Character Class Mis-Match']
          end
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
          item.should_receive(:archetypes).twice.
              and_return([fighter])
          drop = Drop.new(character: raid_main, item: item, loot_method: 'n',
                          loot_type: trash)
          raid_main.should_receive(:general_alternates).
              and_return([general_alternate])

          DropAssignmentValidator.new(drop).validate.
              should eql ['Loot via Need for Trash Item']
        end
      end
      context 'via random' do
        it 'signifies an issue' do
          item = mock_model(Item, loot_type: trash)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'r',
                          loot_type: trash)
          raid_main.should_receive(:raid_alternate).
              and_return(raid_alternate)

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