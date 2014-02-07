require 'spec_helper'
require 'drop_spec_helper'

describe Drop do
  include DropSpecHelper

  around do |example|
    Timecop.travel(Time.zone.local(2013, 04, 01, 20, 15, 01)) do
      example.run
    end
  end

  let(:armour) { mock_model(LootType, name: 'Armour',
                            default_loot_method: 'n') }
  let(:weapon) { mock_model(LootType, name: 'Weapon',
                            default_loot_method: 'n') }
  let(:trade_skill) { mock_model(LootType, name: 'Trade Skill',
                                 default_loot_method: 'g') }
  let(:spell) { mock_model(LootType, name: 'Spell', default_loot_method: 'g') }
  let(:trash) { mock_model(LootType, name: 'Trash', default_loot_method: 't') }

  let(:fighter) { mock_model(Archetype, name: 'Fighter') }
  let(:scout) { mock_model(Archetype, name: 'Scout') }
  let(:priest) { mock_model(Player, name: 'Fred') }

  let(:player) { mock_model(Player, name: 'Fred') }
  let(:raid_main) { mock_model(Character, name: 'Barny', player: player,
                               char_type: 'm', archetype: fighter) }
  let(:raid_alternate) { mock_model(Character, name: 'Betty', player: player,
                                    char_type: 'r', archetype: scout) }
  let(:general_alternate) { mock_model(Character, name: 'Wilma', player: player,
                                       char_type: 'g', archetype: priest) }

  context 'associations' do
    it { should belong_to :instance }
    it { should belong_to :zone }
    it { should belong_to :mob }
    it { should belong_to :character }
    it { should belong_to :item }
    it { should belong_to :loot_type }
  end

  context 'validations' do
    it { should allow_value('n').for(:loot_method) }
    it { should allow_value('r').for(:loot_method) }
    it { should allow_value('b').for(:loot_method) }
    it { should allow_value('g').for(:loot_method) }
    it { should allow_value('t').for(:loot_method) }
    it { should allow_value('m').for(:loot_method) }

    it { should validate_presence_of(:instance_id) }
    it { should validate_presence_of(:zone_id) }
    it { should validate_presence_of(:mob_id) }
    it { should validate_presence_of(:character_id) }
    it { should validate_presence_of(:item_id) }
    it { should validate_presence_of(:loot_method) }
  end

  context 'scopes' do
    context 'for general filtering' do
      let(:d1) { FactoryGirl.create(:drop) }
      let(:d2) { FactoryGirl.create(:drop) }

      describe 'default' do
        it 'does not include chat by default' do
          FactoryGirl.create(:drop)

          expect {
            Drop.first.chat
          }.to raise_exception ActiveModel::MissingAttributeError
        end
        it 'includes the chat if requested' do
          FactoryGirl.create(:drop)

          expect {
            Drop.select('drops.*').first.chat
          }.to_not raise_exception
        end
      end

      describe 'by_character' do
        it 'returns a full list by default' do
          Drop.by_character(nil).order(:id).should match_array [d1, d2]
        end
        it 'filters by character when provided an id' do
          Drop.by_character(d2.character_id).should match_array [d2]
        end
      end

      describe 'by_instance' do
        it 'returns a full list by default' do
          Drop.by_instance(nil).order(:id).should match_array [d1, d2]
        end
        it 'filters by instance when provided an id' do
          Drop.by_instance(d1.instance_id).should match_array [d1]
        end
      end

      describe 'by_zone' do
        it 'returns a full list by default' do
          Drop.by_zone(nil).order(:id).should match_array [d1, d2]
        end
        it 'filters by zone when provided an id' do
          Drop.by_zone(d2.zone_id).should match_array [d2]
        end
      end

      describe 'by_mob' do
        it 'returns a full list by default' do
          Drop.by_mob(nil).order(:id).should match_array [d1, d2]
        end
        it 'filters by mob when provided an id' do
          Drop.by_mob(d1.mob_id).should match_array [d1]
        end
      end

      describe 'by_item' do
        it 'returns a full list by default' do
          Drop.by_item(nil).order(:id).should match_array [d1, d2]
        end
        it 'filters by item when provided an id' do
          Drop.by_item(d2.item_id).should match_array [d2]
        end
      end

      describe 'by_log_line' do
        it 'returns a full list by default' do
          Drop.by_log_line(nil).order(:id).should match_array [d1, d2]
        end
        it 'filters by log line when provided an id' do
          Drop.by_log_line(d1.log_line).should match_array [d1]
        end
      end

      describe 'by_eq2_item_id' do
        it 'returns a full list by default' do
          Drop.by_eq2_item_id(nil).order(:id).should match_array [d1, d2]
        end
        it 'filters by eq2 item id when provided an id' do
          Drop.by_eq2_item_id(d2.eq2_item_id).should match_array [d2]
        end
      end

      describe 'of_type' do
        it 'filters by loot type name' do
          Drop.of_type(d1.loot_type_name).should match_array [d1]
        end
      end

      describe 'by_archetype' do
        it 'returns a full list by default' do
          Drop.by_archetype(nil).order(:id).should match_array [d1, d2]
        end
        it 'filters by archetype name' do
          Drop.by_archetype(d1.character.archetype_name).should match_array [d1]
        end
      end

      describe 'by_player' do
        it 'returns a full list by default' do
          Drop.by_player(nil).order(:id).should match_array [d1, d2]
        end
        it 'filters by player when provided an id' do
          Drop.by_player(d2.character.player_id).should match_array [d2]
        end
      end

      describe 'by_time' do
        it 'returns a full list by default' do
          Drop.by_time(nil).order(:id).should match_array [d1, d2]
        end

        it 'filters by a time string' do
          Drop.by_time(d1.drop_time.to_s).should match_array [d1]
        end

        it 'filters by a time object' do
          Drop.by_time(d2.drop_time).should match_array [d2]
        end
      end

      describe 'won_by' do
        it 'filters based on a string' do
          d3 = FactoryGirl.create(:drop, loot_method: 'r')

          Drop.won_by('r').should match_array [d3]
        end
        it 'filters based on an array' do
          d3 = FactoryGirl.create(:drop, loot_method: 'r')
          d4 = FactoryGirl.create(:drop, loot_method: 'b')

          Drop.won_by(%w{b r}).order(:id).should match_array [d3, d4]
        end
      end

      describe 'not_won_by' do
        it 'filters based on a string' do
          d3 = FactoryGirl.create(:drop, loot_method: 'r')

          Drop.not_won_by('n').should match_array [d3]
        end
        it 'filters based on an array' do
          FactoryGirl.create(:drop, loot_method: 'r')
          FactoryGirl.create(:drop, loot_method: 'b')

          Drop.not_won_by(%w{b r}).order(:id).should match_array [d1, d2]
        end
      end

      describe 'by_character_type' do
        it 'uses the character type from the associated character' do
          char1 = FactoryGirl.create(:character, char_type: 'm')
          char2 = FactoryGirl.create(:character, char_type: 'r')
          d3 = FactoryGirl.create(:drop, character: char1, drop_time: 2.weeks.ago)
          d4 = FactoryGirl.create(:drop, character: char2, drop_time: 2.weeks.ago)

          Drop.by_character_type('m').should match_array [d3]
        end
        it 'filters based on a string' do
          char1 = FactoryGirl.create(:character, char_type: 'm')
          char2 = FactoryGirl.create(:character, char_type: 'r')
          char3 = FactoryGirl.create(:character, char_type: 'g')
          d3 = FactoryGirl.create(:drop, character: char1)
          d4 = FactoryGirl.create(:drop, character: char2)
          d5 = FactoryGirl.create(:drop, character: char3)

          Drop.by_character_type('g').should match_array [d5]
        end
        it 'filters based on an array' do
          char1 = FactoryGirl.create(:character, char_type: 'm')
          char2 = FactoryGirl.create(:character, char_type: 'r')
          char3 = FactoryGirl.create(:character, char_type: 'g')
          d3 = FactoryGirl.create(:drop, character: char1)
          d4 = FactoryGirl.create(:drop, character: char2)
          d5 = FactoryGirl.create(:drop, character: char3)

          Drop.by_character_type(%w{g r}).should match_array [d4, d5]
        end
      end

      describe 'with_default_loot_method' do
        it 'filters based on an array' do
          ts = FactoryGirl.create(:loot_type, default_loot_method: 'g')
          trash = FactoryGirl.create(:loot_type, default_loot_method: 't')
          recipe = FactoryGirl.create(:item, loot_type: ts)
          body_drop = FactoryGirl.create(:item, loot_type: trash)
          d3 = FactoryGirl.create(:drop, item: recipe)
          d4 = FactoryGirl.create(:drop, item: body_drop)

          Drop.with_default_loot_method(%w{g t}).should match_array [d3, d4]
        end

        it 'filters based on the items loot type' do
          ts = FactoryGirl.create(:loot_type, default_loot_method: 'r')
          recipe = FactoryGirl.create(:item, loot_type: ts)
          d3 = FactoryGirl.create(:drop, item: recipe)

          Drop.with_default_loot_method('r').should match_array [d3]
        end
      end
    end

    context 'identifying invalidly assigned drops' do
      describe 'mismatched_loot_types' do
        it 'identifies drops with a loot type different from its item' do
          ts = FactoryGirl.create(:loot_type, default_loot_method: 'r')
          recipe = FactoryGirl.create(:item)
          d3 = FactoryGirl.create(:drop, item: recipe, loot_type: ts)

          Drop.mismatched_loot_types.should match_array [d3]
        end
      end

      describe 'invalid_need_assignment' do
        it 'identifies drops looted via need by a general alt' do
          ga = FactoryGirl.create(:character, char_type: 'g')
          d3 = FactoryGirl.create(:drop, character: ga)
          FactoryGirl.create(:character_type, character: ga, char_type: 'g')

          Drop.invalid_need_assignment.should match_array [d3]
        end
      end

      describe 'invalid_guild_bank_assignment' do
        it 'identifies incorrectly assigned guild bank drops' do
          gb = FactoryGirl.create(:loot_type, default_loot_method: 'g')
          spell = FactoryGirl.create(:item, loot_type: gb)
          d3 = FactoryGirl.create(:drop, item: spell, loot_method: 'b')
          d4 = FactoryGirl.create(:drop, item: spell, loot_method: 'n')

          Drop.invalid_guild_bank_assignment.order(:id).
              should match_array [d3, d4]
        end
      end

      describe 'invalid_trash_assignment' do
        it 'identifies trash item drops that were not won as trash items' do
          trash = FactoryGirl.create(:loot_type, default_loot_method: 't')
          item = FactoryGirl.create(:item, loot_type: trash)
          d3 = FactoryGirl.create(:drop, item: item, loot_method: 'n')
          d4 = FactoryGirl.create(:drop, item: item, loot_method: 'b')
          d5 = FactoryGirl.create(:drop, item: item, loot_method: 'r')

          Drop.invalid_trash_assignment.sort{ |a,b| a.id <=> b.id}.
              should match_array [d3, d4, d5]
        end

        it 'identifies bid, need and random items won as trash' do
          armour = FactoryGirl.create(:loot_type, default_loot_method: 'n')
          mount = FactoryGirl.create(:loot_type, default_loot_method: 'b')
          spell = FactoryGirl.create(:loot_type, default_loot_method: 'r')
          helm = FactoryGirl.create(:item, loot_type: armour)
          drake = FactoryGirl.create(:item, loot_type: mount)
          smite = FactoryGirl.create(:item, loot_type: spell)

          d3 = FactoryGirl.create(:drop, item: helm, loot_method: 't')
          d4 = FactoryGirl.create(:drop, item: drake, loot_method: 't')
          d5 = FactoryGirl.create(:drop, item: smite, loot_method: 't')

          Drop.invalid_trash_assignment.sort{ |a,b| a.id <=> b.id}.
              should match_array [d3, d4, d5]
        end
      end

      describe 'invalidly_assigned' do
        context 'when validating trash' do
          it 'calls all the methods' do
              Drop.should_receive(:mismatched_loot_types).and_return([])
              Drop.should_receive(:invalid_need_assignment).and_return([])
              Drop.should_receive(:invalid_guild_bank_assignment).and_return([])
              Drop.should_receive(:invalid_trash_assignment).and_return([])

              Drop.invalidly_assigned(true)
          end
        end

        context 'when not validating trash' do
          it 'calls all the normal methods' do
            Drop.should_receive(:mismatched_loot_types).and_return([])
            Drop.should_receive(:invalid_need_assignment).and_return([])
            Drop.should_receive(:invalid_guild_bank_assignment).and_return([])

            Drop.invalidly_assigned
          end

          it 'should not validate trash drops' do
            Drop.should_not_receive(:invalid_trash_assignment)
            Drop.invalidly_assigned
          end
        end
      end
    end
  end

  describe '#loot_method_name' do
    it "should return 'Need' when loot_method is 'n'" do
      drop = Drop.new(loot_method: 'n')

      drop.loot_method_name.should eq 'Need'
    end

    it "should return 'Trash' when loot_method is 't'" do
      drop = Drop.new(loot_method: 't')

      drop.loot_method_name.should eq 'Trash'
    end

    it "should return 'Transmuted' when loot_method is 'm'" do
      drop = Drop.new(loot_method: 'm')

      drop.loot_method_name.should eq 'Transmuted'
    end

    it "should return 'Random' when loot_method is 'r'" do
      drop = Drop.new(loot_method: 'r')

      drop.loot_method_name.should eq 'Random'
    end

    it "should return 'Guild Bank' when loot_method is 'g'" do
      drop = Drop.new(loot_method: 'g')

      drop.loot_method_name.should eq 'Guild Bank'
    end

    it "should return 'Bid' when loot_method is 'b'" do
      drop = Drop.new(loot_method: 'b')

      drop.loot_method_name.should eq 'Bid'
    end

    it "should return 'Unknown' when loot_method is invalid" do
      drop = Drop.new(loot_method: '?')

      drop.loot_method_name.should eq 'Unknown'
    end

    it "should return 'Need' when loot_method is null" do
      drop = Drop.new

      drop.loot_method_name.should eq 'Need'
    end
  end

  describe '#assignment_issues' do
    it 'uses a DropAssignmentsValidator' do
      drop = FactoryGirl.create(:drop)
      validator = double(DropAssignmentValidator)
      DropAssignmentValidator.should_receive(:new).
          with(drop).and_return(validator)
      validator.should_receive(:validate)

      drop.assignment_issues
    end
  end

  describe '#invalid_reason' do
    it 'is empty when there are no assignment issues' do
      item = mock_model(Item, loot_type: armour)
      drop = Drop.new(character: raid_main,
                      item: item,
                      loot_method: 'n',
                      loot_type: weapon)
      drop.should_receive(:assignment_issues).and_return([])

      drop.invalid_reason.should eq ''
    end

    it 'returns a comma separated list of assignment issues' do
      item = mock_model(Item, loot_type: armour)
      drop = Drop.new(character: raid_main,
                      item: item,
                      loot_method: 'n',
                      loot_type: weapon)
      drop.should_receive(:assignment_issues).twice.
          and_return(['This is invalid!', 'This is invalid too!'])

      drop.invalid_reason.should eq 'This is invalid!, This is invalid too!'
    end
  end

  describe '#correctly_assigned?' do
    it 'is true when assignment_issues is empty' do
      item = mock_model(Item, loot_type: armour)
      drop = Drop.new(character: raid_main,
                      item: item,
                      loot_method: 'n',
                      loot_type: weapon)
      drop.should_receive(:assignment_issues).and_return([])

      drop.correctly_assigned?.should be_true
    end

    it 'is false when assignment_issues is not empty' do
      item = mock_model(Item, loot_type: armour)
      drop = Drop.new(character: raid_main, item: item,
                      loot_method: 'n', loot_type: weapon)
      drop.should_receive(:assignment_issues).and_return(%w{Oops!})

      drop.correctly_assigned?.should be_false
    end
  end

  describe '#to_s' do
    it 'displays the item, character, drop time and zone_name' do
      drop = FactoryGirl.create(:drop)
      drop.to_s.should eq "#{drop.item_name} looted by #{drop.character_name} on #{drop.drop_time} in #{drop.zone_name}"
    end
  end
end
