require 'spec_helper'
require 'character_spec_helper'

describe Character do
  include CharacterSpecHelper

  before(:each) do
    @character = FactoryGirl.create(:character, valid_character_attributes)
  end

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
    it { should have_many(:adjustments).dependent(:destroy) }
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
    it 'should require :archetype_id on update' do
      mm = FactoryGirl.create(:character)
      mm.archetype_id = nil
      mm.save
      mm.valid?.should be_false
      mm.errors[:archetype_id].should eq(["can't be blank"])
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
      mm.char_type = "f"
      mm.save
      mm.valid?.should be_false
      mm.errors[:char_type].should include("is invalid")
    end
    it { should validate_format_of(:char_type).with(/g|m|r/)}
  end

  context 'instance methods' do
    describe '#player_name' do
      it 'returns Unknown when the player is nil' do
        character = Character.new

        character.player_name.should eq('Unknown')
      end

      it 'returns the player name when the player is set' do
        @character.player_name.should eq('Uber')
      end
    end

    describe '#archetype_name' do
      it 'returns Unknown when the archetype is nil' do
        character = Character.new

        character.archetype_name.should eq('Unknown')
      end

      it 'returns the archetype name when the archetype is set' do
        @character.archetype_name.should eq('Mage')
      end
    end

    describe '#loot_rate' do
      it 'should calculate to two decimal places' do
        num_raids = 37
        num_items = 5

        loot_rate = @character.calculate_loot_rate(num_raids, num_items)
        loot_rate.should == 6.17
      end
    end

    describe '#to_csv' do
      it "should return csv" do
        csv = FactoryGirl.create(:character, valid_character_attributes.merge!(:name => 'CSV')).to_csv

        csv.should match('CSV')
        csv.should match('Raid Main')
        csv.split(",").count.should == 11
      end
    end

    it "should give the char_type at a particular time" do
      character = FactoryGirl.create(:character, valid_character_attributes.merge!(:name => 'switching to main'))
      FactoryGirl.create(:character_type, :character_id => character.id, :char_type => 'g', :effective_date => Date.parse("01/01/2012"))
      FactoryGirl.create(:character_type, :character_id => character.id, :char_type => 'r', :effective_date => Date.parse("01/03/2012"))
      FactoryGirl.create(:character_type, :character_id => character.id, :char_type => 'm', :effective_date => Date.parse("01/06/2012"))

      character.rank_at_time(Date.parse("01/02/2012")).should eq 'g'
      character.rank_at_time(Date.parse("01/03/2012")).should eq 'r'
      character.rank_at_time(Date.parse("01/06/2012")).should eq 'm'
    end

    context "#archetype_name" do
      it "should show the archetype name when the archetype is valid" do
        mage = FactoryGirl.create(:character, valid_character_attributes.merge!(:name => 'mage'))

        mage.archetype_name.should eq 'Mage'
      end

      it "should have an archetype name of Unknown when the archetype is not valid" do
        unknown = Character.new

        unknown.archetype_name.should eq 'Unknown'
      end
    end

    context "#archetype_root" do
      it "should show the root archetype name when it has one" do
        fighter = FactoryGirl.create(:archetype, name: 'Fighter')
        brawler = FactoryGirl.create(:archetype, name: 'Brawler', parent_id: fighter.id)
        character = FactoryGirl.create(:character, valid_character_attributes.merge!(name: 'brawler', archetype_id: brawler.id))

        character.archetype_root.should eq 'Fighter'
      end

      it "should show Unknown if it does not have an archetype" do
        unknown = Character.new

        unknown.archetype_root.should eq 'Unknown'
      end
    end
  end
end