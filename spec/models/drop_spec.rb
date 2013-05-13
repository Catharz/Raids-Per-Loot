require 'spec_helper'
require 'drop_spec_helper'

describe Drop do
  include DropSpecHelper

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

  describe '#invalid_reason' do
    it 'is empty when there are no assignment issues' do
      item = mock_model(Item, loot_type: armour)
      drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: weapon)
      drop.should_receive(:assignment_issues).and_return([])

      drop.invalid_reason.should eq ''
    end

    it 'returns a comma separated list of assignment issues' do
      item = mock_model(Item, loot_type: armour)
      drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: weapon)
      drop.should_receive(:assignment_issues).twice.and_return(['This is invalid!', 'This is invalid too!'])

      drop.invalid_reason.should eq 'This is invalid!, This is invalid too!'
    end
  end

  describe '#correctly_assigned?' do
    it 'is true when assignment_issues is empty' do
      item = mock_model(Item, loot_type: armour)
      drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: weapon)
      drop.should_receive(:assignment_issues).and_return([])

      drop.correctly_assigned?.should be_true
    end

    it 'is false when assignment_issues is not empty' do
      item = mock_model(Item, loot_type: armour)
      drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: weapon)
      drop.should_receive(:assignment_issues).and_return(%w{Oops!})

      drop.correctly_assigned?.should be_false
    end
  end
end