require 'spec_helper'

describe Adjustment do
  before(:each) do
    main = FactoryGirl.create(:rank, name: 'Main')
    @betty = FactoryGirl.create(:player, name: 'Betty', rank_id: main.id)
    @wilma = FactoryGirl.create(:player, name: 'Wilma', rank_id: main.id)
    @fred = FactoryGirl.create(:character, name: 'Fred', char_type: 'm')
    @barny = FactoryGirl.create(:character, name: 'Barney', char_type: 'm')
  end

  describe "self.for_character" do
    it "should filter by character_id" do
      adj1 = FactoryGirl.create(:adjustment,
                                adjustable_type: 'Character',
                                adjustable_id: @fred.id,
                                reason: "Whatever",
                                amount: 6)
      adj2 = FactoryGirl.create(:adjustment,
                                adjustable_type: 'Character',
                                adjustable_id: @fred.id,
                                reason: "Some Other Reason",
                                amount: 3)
      adj3 = FactoryGirl.create(:adjustment,
                                adjustable_type: 'Character',
                                adjustable_id: @barny.id,
                                reason: "Testing",
                                amount: 1)

      Adjustment.for_character(@fred.id).order(:id).should eq [adj1, adj2]
      Adjustment.for_character(@barny.id).should eq [adj3]
    end
  end

  describe "self.for_player" do
    it "should filter by player_id" do
      adj1 = FactoryGirl.create(:adjustment,
                                adjustable_type: 'Player',
                                adjustable_id: @betty.id,
                                reason: "Whatever",
                                amount: 3)
      adj2 = FactoryGirl.create(:adjustment,
                                adjustable_type: 'Player',
                                adjustable_id: @betty.id,
                                reason: "Some Other Reason",
                                amount: 2)
      adj3 = FactoryGirl.create(:adjustment,
                                adjustable_type: 'Player',
                                adjustable_id: @wilma.id,
                                reason: "Testing",
                                amount: 1)

      Adjustment.for_player(@betty.id).order(:id).should eq [adj1, adj2]
      Adjustment.for_player(@wilma.id).should eq [adj3]
    end
  end

  describe "self.by_adjustable_type" do
    it "should filter by adjustable type" do
      adj1 = FactoryGirl.create(:adjustment, adjustable_type: 'Character', adjustable_id: @fred.id)
      adj2 = FactoryGirl.create(:adjustment, adjustable_type: 'Character', adjustable_id: @fred.id)
      adj3 = FactoryGirl.create(:adjustment, adjustable_type: 'Character', adjustable_id: @barny.id)
      adj4 = FactoryGirl.create(:adjustment, adjustable_type: 'Player', adjustable_id: @betty.id)
      adj5 = FactoryGirl.create(:adjustment, adjustable_type: 'Player', adjustable_id: @betty.id)
      adj6 = FactoryGirl.create(:adjustment, adjustable_type: 'Player', adjustable_id: @wilma.id)

      Adjustment.by_adjustable_type('Character').order(:id).should eq [adj1, adj2, adj3]
      Adjustment.by_adjustable_type('Player').order(:id).should eq [adj4, adj5, adj6]
    end
  end

  describe "self.by_adjustment_type" do
    it "should filter by adjustment type" do
      adj1 = FactoryGirl.create(:adjustment, adjustable_type: 'Character', adjustment_type: 'Raids', adjustable_id: @fred.id)
      adj2 = FactoryGirl.create(:adjustment, adjustable_type: 'Character', adjustment_type: 'Instances', adjustable_id: @fred.id)
      adj3 = FactoryGirl.create(:adjustment, adjustable_type: 'Character', adjustment_type: 'Raids', adjustable_id: @barny.id)
      adj4 = FactoryGirl.create(:adjustment, adjustable_type: 'Player', adjustment_type: 'Instances', adjustable_id: @betty.id)
      adj5 = FactoryGirl.create(:adjustment, adjustable_type: 'Player', adjustment_type: 'Raids', adjustable_id: @betty.id)
      adj6 = FactoryGirl.create(:adjustment, adjustable_type: 'Player', adjustment_type: 'Instances', adjustable_id: @wilma.id)

      Adjustment.by_adjustment_type('Raids').order(:id).should eq [adj1, adj3, adj5]
      Adjustment.by_adjustment_type('Instances').order(:id).should eq [adj2, adj4, adj6]
    end
  end

  describe "name" do
    it "returns 'Unknown' if the name is not present" do
      adj1 = Adjustment.new

      adj1.name.should eq "Unknown"
    end

    it "returns the character name for a character adjustment" do
      adj1 = FactoryGirl.create(:adjustment, adjustable_type: 'Character', adjustment_type: 'Raids', adjustable_id: @fred.id)

      adj1.name.should eq "Fred"
    end

    it "returns the player name for a player adjustment" do
      adj1 = FactoryGirl.create(:adjustment, adjustable_type: 'Player', adjustment_type: 'Instances', adjustable_id: @betty.id)

      adj1.name.should eq "Betty"
    end
  end

  describe "adjustment_types" do
    it "should return Raids and Instances by default" do
      adj1 = Adjustment.new

      adj1.adjustment_types.should include "Raids"
      adj1.adjustment_types.should include "Instances"
    end
  end

  describe "type_label" do
    it "should show Player for a player adjustment" do
      adj1 = FactoryGirl.create(:adjustment, adjustable_type: 'Player', adjustment_type: 'Instances', adjustable_id: @betty.id)

      adj1.type_label.should eq "Player:"
    end

    it "should show Character for a character adjustment" do
      adj1 = FactoryGirl.create(:adjustment, adjustable_type: 'Character', adjustment_type: 'Raids', adjustable_id: @fred.id)

      adj1.type_label.should eq "Character:"
    end

    it "should have a generic label for new adjustments" do
      adj1 = Adjustment.new

      adj1.type_label.should eq "Player/Character:"
    end
  end

  describe "adjustable_entities" do
    it "should list players for a player adjustment type" do
      adj1 = FactoryGirl.create(:adjustment, adjustable_type: 'Character', adjustment_type: 'Raids', adjustable_id: @fred.id)

      adj1.adjustable_entities.should eq [@barny, @fred]
    end

    it "should list characters for a character adjustment type" do
      adj1 = FactoryGirl.create(:adjustment, adjustable_type: 'Player', adjustment_type: 'Instances', adjustable_id: @betty.id)

      adj1.adjustable_entities.order(:id).should eq [@betty, @wilma]
    end
  end
end