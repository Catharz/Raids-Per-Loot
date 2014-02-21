require 'spec_helper'

describe Character do
  fixtures :archetypes

  context 'associations' do
    it { should belong_to(:player) }
    it { should belong_to(:archetype) }

    it { should have_many(:drops) }
    it { should have_many(:character_instances) }
    it { should have_many(:character_types) }
    it { should have_one(:last_switch).class_name('CharacterType') }
    it { should have_many(:items).through(:drops) }
    it { should have_many(:instances).through(:character_instances) }
    it { should have_many(:raids).through(:instances) }
    it { should have_one(:external_data).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it 'should require :player on update' do
      mm = FactoryGirl.create(:character)
      mm.player = nil
      mm.save
      mm.valid?.should be_false
      mm.errors[:player].should eq(["can't be blank"])
    end
    it 'should require :archetype on update' do
      mm = FactoryGirl.create(:character)
      mm.archetype = nil
      mm.save
      mm.valid?.should be_false
      mm.errors[:archetype].should eq(["can't be blank"])
    end
    it 'should require :char_type on update' do
      mm = FactoryGirl.create(:character)
      mm.char_type = nil
      mm.save
      mm.valid?.should be_false
      mm.errors[:char_type].should include("can't be blank")
    end
    it 'should require :char_type to be valid on update' do
      mm = FactoryGirl.create(:character)
      mm.char_type = 'f'
      mm.save
      mm.valid?.should be_false
      mm.errors[:char_type].should include('is invalid')
    end
    it { should allow_value('g').for(:char_type) }
    it { should allow_value('m').for(:char_type) }
    it { should allow_value('r').for(:char_type) }
  end

  context 'instance method' do
    describe '#to_s' do
      it 'includes the name and archetype name' do
        character = FactoryGirl.create(:character)
        character.to_s.should eq "#{character.name} (#{character.archetype.name})"
      end
    end

    describe '#loot_rate' do
      it 'should calculate to two decimal places' do
        character = FactoryGirl.create(:character)
        num_raids = 37
        num_items = 5

        loot_rate = character.calculate_loot_rate(num_raids, num_items)
        loot_rate.should == 6.17
      end
    end

    describe '#path' do
      it 'returns a url to the character' do
        char = FactoryGirl.create(:character)

        char.path.should eq '<a href="/characters/' +
                                char.id.to_s + '">' + char.name + '</a>'
      end

      it 'allows providing options' do
        char = FactoryGirl.create(:character)

        char.path(format: 'json').should eq '<a href="/characters/' +
                                                char.id.to_s +
                                                '" format="json">' +
                                                char.name + '</a>'
      end
    end

    describe '#html_id' do
      it 'returns a unique id for each character' do
        char1 = FactoryGirl.create(:character)
        char2 = FactoryGirl.create(:character)

        char1.html_id.should eq "character_#{char1.id}"
        char2.html_id.should eq "character_#{char2.id}"
      end
    end

    context 'player character type' do
      before(:each) do
        @player = FactoryGirl.create(:player)
        @main = FactoryGirl.create(:character, char_type: 'm', player: @player)
        @raid_alt = FactoryGirl.create(:character, char_type: 'r',
                                       player: @player)
        @gen_alt1 = FactoryGirl.create(:character, char_type: 'g',
                                       player: @player)
        @gen_alt2 = FactoryGirl.create(:character, char_type: 'g',
                                       player: @player)
        [@main, @raid_alt, @gen_alt1, @gen_alt2].each do |char|
          FactoryGirl.create(:character_type, character: char,
                             char_type: char.char_type)
        end
      end

      describe 'main_character' do
        context 'with no player' do
          it 'is a null character if not the main character' do
            char = FactoryGirl.create(:character, char_type: 'g')
            char.should_receive(:player).and_return(nil)

            char.main_character.should be_a NullCharacter
          end

          it 'is itself if the main character' do
            char = FactoryGirl.create(:character, char_type: 'm')
            FactoryGirl.create(:character_type, character: char, char_type: 'm')

            char.main_character.should eq char
          end
        end

        it 'works when asking the main character' do
          @main.main_character.should eq @main
        end

        it 'works when asking the raid alternate' do
          @raid_alt.main_character.should eq @main
        end

        it 'works when asking any of the general alternates' do
          @gen_alt1.main_character.should eq @main
          @gen_alt2.main_character.should eq @main
        end
      end

      describe 'raid_alternate' do
        context 'with no player' do
          it 'is a null character if not the raid alternate' do
            char = FactoryGirl.create(:character, char_type: 'm')
            char.should_receive(:player).and_return(nil)

            char.raid_alternate.should be_a NullCharacter
          end

          it 'is itself if the raid alternate' do
            char = FactoryGirl.create(:character, char_type: 'r')
            char.should_receive(:player).and_return(nil)

            char.raid_alternate.should eq char
          end
        end

        it 'works when asking the main character' do
          @main.raid_alternate.should eq @raid_alt
        end

        it 'works when asking the raid alternate' do
          @raid_alt.raid_alternate.should eq @raid_alt
        end

        it 'works when asking any of the general alternates' do
          @gen_alt1.raid_alternate.should eq @raid_alt
          @gen_alt2.raid_alternate.should eq @raid_alt
        end
      end

      describe 'general_alternates' do
        context 'with no player' do
          it 'is empty if not a general alternate' do
            char = FactoryGirl.create(:character, char_type: 'm')
            char.should_receive(:player).and_return(nil)

            char.general_alternates.should eq []
          end

          it 'is itself if a general alternate' do
            char = FactoryGirl.create(:character, char_type: 'g')
            char.should_receive(:player).and_return(nil)

            char.general_alternates.should eq [char]
          end
        end

        it 'works when asking the main character' do
          @main.general_alternates.should match_array [@gen_alt1, @gen_alt2]
        end

        it 'works when asking the raid alternate' do
          @raid_alt.general_alternates.should match_array [@gen_alt1, @gen_alt2]
        end

        it 'works when asking any of the general alternates' do
          @gen_alt1.general_alternates.should match_array [@gen_alt1, @gen_alt2]
          @gen_alt2.general_alternates.should match_array [@gen_alt1, @gen_alt2]
        end
      end
    end

    describe '#to_csv' do
      it 'should return csv' do
        csv = FactoryGirl.create(:character, name: 'CSV').to_csv

        csv.should match('CSV')
        csv.should match('Raid Main')
        csv.split(',').count.should == 19
      end
    end

    it 'should give the char_type at a particular time' do
      character = FactoryGirl.create(:character, name: 'switching to main')
      FactoryGirl.create(:character_type, character_id: character.id,
                         char_type: 'g',
                         effective_date: Date.parse('01/01/2012'))
      FactoryGirl.create(:character_type, character_id: character.id,
                         char_type: 'r',
                         effective_date: Date.parse('01/03/2012'))
      FactoryGirl.create(:character_type, character_id: character.id,
                         char_type: 'm',
                         effective_date: Date.parse('01/06/2012'))

      character.rank_at_time(Date.parse('01/02/2012')).should eq 'g'
      character.rank_at_time(Date.parse('01/03/2012')).should eq 'r'
      character.rank_at_time(Date.parse('01/06/2012')).should eq 'm'
    end

    context '#archetype_root' do
      it 'should show the root archetype name when it has one' do
        character =
            FactoryGirl.create(:character,
                               archetype: Archetype.find_by_name('Monk'))

        character.archetype_root.should eq 'Fighter'
      end

      it 'should show Unknown if it does not have an archetype' do
        unknown = Character.new

        unknown.archetype_root.should eq 'Unknown'
      end
    end
  end

  context 'scopes' do
    before(:each) do
      @fighter = Archetype.find_by_name('Fighter')
      @brawler = Archetype.find_by_name('Brawler')
      @bruiser = Archetype.find_by_name('Bruiser')
      @monk = Archetype.find_by_name('Monk')
      @paladin = Archetype.find_by_name('Paladin')

      @player1 = FactoryGirl.create(:player)
      @player2 = FactoryGirl.create(:player)
      @rhubarb = FactoryGirl.create(:character, name: 'Rhubarb',
                                    char_type: 'm',
                                    player: @player1,
                                    archetype: @bruiser)
      @strawberry = FactoryGirl.create(:character, name: 'Strawberry',
                                       char_type: 'm',
                                       player: @player2,
                                       archetype: @monk)
      @blueberry = FactoryGirl.create(:character, name: 'Blueberry',
                                      char_type: 'g',
                                      player: @player2,
                                      archetype: @paladin)
    end

    describe 'by_name' do
      it 'finds all characters by default' do
        Character.by_name(nil).
            should match_array [@rhubarb, @strawberry, @blueberry]
      end

      it 'finds characters by name' do
        Character.by_name('Rhubarb').should eq [@rhubarb]
      end
    end

    describe 'by_char_type' do
      it 'finds all character by default' do
        Character.by_char_type(nil).
            should match_array [@rhubarb, @strawberry, @blueberry]
      end

      it 'finds characters by character Type' do
        Character.by_char_type('g').should eq [@blueberry]
      end
    end

    describe 'by_instance' do
      it 'finds all characters by default' do
        Character.by_instance(nil).
            should match_array [@rhubarb, @strawberry, @blueberry]
      end

      it 'finds characters who raided a particular instance' do
        instance = FactoryGirl.create(:instance)

        FactoryGirl.create(:character_instance,
                           character_id: @strawberry.id,
                           instance_id: instance.id)

        Character.by_instance(instance.id).should eq [@strawberry]
      end
    end

    describe 'by_player' do
      it 'finds all by default' do
        Character.by_player(nil).
            should match_array [@rhubarb, @strawberry, @blueberry]
      end

      it 'finds characters belonging to a specify player' do
        Character.by_player(@player2.id).
            should match_array [@strawberry, @blueberry]
      end
    end

    describe 'find_by_archetype' do
      it 'finds just the monk' do
        Character.find_by_archetype(@monk).should eq [@strawberry]
      end

      it 'finds the brawlers' do
        Character.find_by_archetype(@brawler).
            should match_array [@rhubarb, @strawberry]
      end

      it 'finds all the fighters' do
        Character.find_by_archetype(@fighter).
            should match_array [@rhubarb, @strawberry, @blueberry]
      end
    end
  end
end