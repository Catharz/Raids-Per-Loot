require 'spec_helper'
require 'drop_spec_helper'

describe Drop do
  include DropSpecHelper

  let(:armour) { mock_model(LootType, name: "Armour", default_loot_method: 'n') }
  let(:weapon) { mock_model(LootType, name: "Weapon", default_loot_method: 'n') }
  let(:trade_skill) { mock_model(LootType, name: "Trade Skill", default_loot_method: 'g') }
  let(:spell) { mock_model(LootType, name: "Spell", default_loot_method: 'g') }
  let(:trash) { mock_model(LootType, name: "Trash", default_loot_method: 't') }

  let(:fighter) { mock_model(Archetype, name: 'Fighter') }
  let(:scout) { mock_model(Archetype, name: 'Scout') }
  let(:priest) { mock_model(Player, name: 'Fred') }

  let(:player) { mock_model(Player, name: 'Fred') }
  let(:raid_main) { mock_model(Character, name: 'Barny', player: player, char_type: 'm', archetype: fighter) }
  let(:raid_alternate) { mock_model(Character, name: 'Betty', player: player, char_type: 'r', archetype: scout) }
  let(:general_alternate) { mock_model(Character, name: 'Wilma', player: player, char_type: 'g', archetype: priest) }

  context "associations" do
    it { should belong_to :instance }
    it { should belong_to :zone }
    it { should belong_to :mob }
    it { should belong_to :character }
    it { should belong_to :item }
    it { should belong_to :loot_type }
  end

  context "validations" do
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

  context "delegations" do
    it { should delegate_method(:zone_name).to(:zone).as(:name) }
    it { should delegate_method(:mob_name).to(:mob).as(:name) }
    it { should delegate_method(:item_name).to(:item).as(:name) }
    it { should delegate_method(:character_name).to(:character).as(:name) }
  end

  describe "#loot_method_name" do
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

  describe "#correctly_assigned?" do
    context "when drop and item loot type do not match" do
      it "should be false" do
        item = mock_model(Item, loot_type: armour)
        item.should_receive(:archetypes).and_return([fighter, scout])
        drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: weapon)
        raid_main.should_receive(:main_character).and_return(raid_main)

        drop.correctly_assigned?.should be_false
      end
    end

    context "when looting a normal item" do
      context "via need" do
        context "for a raid main" do
          context "of the right archetype" do
            it "should be true" do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).and_return([fighter, scout])
              drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: armour)
              raid_main.should_receive(:main_character).and_return(raid_main)

              drop.correctly_assigned?.should be_true
            end
          end
          context "of the wrong archetype" do
            it "should be false" do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).and_return([priest])
              drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: armour)
              raid_main.should_receive(:main_character).and_return(raid_main)

              drop.correctly_assigned?.should be_false
            end
          end
        end
        context "for a raid alternate" do
          it "should be false" do
            item = mock_model(Item, loot_type: armour)
            drop = Drop.new(character: raid_alternate, item: item, loot_method: 'n', loot_type: armour)
            raid_alternate.should_receive(:main_character).and_return(raid_main)

            drop.correctly_assigned?.should be_false
          end
        end
        context "for a general alternate" do
          it "should be false" do
            item = mock_model(Item, loot_type: armour)
            drop = Drop.new(character: general_alternate, item: item, loot_method: 'n', loot_type: armour)
            general_alternate.should_receive(:main_character).and_return(raid_main)

            drop.correctly_assigned?.should be_false
          end
        end
      end

      context "via random" do
        context "for a raid main" do
          it "should be false" do
            item = mock_model(Item, loot_type: armour)
            drop = Drop.new(character: raid_main, item: item, loot_method: 'r', loot_type: armour)
            raid_main.should_receive(:raid_alternate).and_return(raid_alternate)

            drop.correctly_assigned?.should be_false
          end
        end
        context "for a raid alternate" do
          context "of the right archetype" do
            it "should be true" do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).and_return([fighter, scout])
              drop = Drop.new(character: raid_alternate, item: item, loot_method: 'r', loot_type: armour)
              raid_alternate.should_receive(:raid_alternate).and_return(raid_alternate)

              drop.correctly_assigned?.should be_true
            end
          end
          context "of the wrong archetype" do
            it "should be false" do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).and_return([priest])
              drop = Drop.new(character: raid_alternate, item: item, loot_method: 'r', loot_type: armour)
              raid_alternate.should_receive(:raid_alternate).and_return(raid_alternate)

              drop.correctly_assigned?.should be_false
            end
          end
        end
        context "for a general alternate" do
          it "should be false" do
            item = mock_model(Item, loot_type: armour)
            drop = Drop.new(character: general_alternate, item: item, loot_method: 'r', loot_type: armour)
            general_alternate.should_receive(:raid_alternate).and_return(raid_alternate)

            drop.correctly_assigned?.should be_false
          end
        end
      end

      context "via bid" do
        context "for raid main" do
          it "should be false" do
            item = mock_model(Item, loot_type: armour)
            drop = Drop.new(character: raid_main, item: item, loot_method: 'b', loot_type: armour)
            raid_main.should_receive(:main_character).and_return(raid_main)

            drop.correctly_assigned?.should be_false
          end
        end
        context "for raid alt" do
          it "should be false" do
            item = mock_model(Item, loot_type: armour)
            drop = Drop.new(character: raid_alternate, item: item, loot_method: 'b', loot_type: armour)
            raid_alternate.should_receive(:main_character).and_return(raid_main)
            raid_alternate.should_receive(:raid_alternate).and_return(raid_alternate)

            drop.correctly_assigned?.should be_false
          end
        end
        context "for general alt" do
          context "of the right archetype" do
            it "should be true" do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).and_return([priest])
              drop = Drop.new(character: general_alternate, item: item, loot_method: 'b', loot_type: armour)
              general_alternate.should_receive(:main_character).and_return(raid_main)
              general_alternate.should_receive(:raid_alternate).and_return(raid_alternate)

              drop.correctly_assigned?.should be_true
            end
          end
          context "of the wrong archetype" do
            it "should be false" do
              item = mock_model(Item, loot_type: armour)
              item.should_receive(:archetypes).and_return([fighter, scout])
              drop = Drop.new(character: general_alternate, item: item, loot_method: 'b', loot_type: armour)
              general_alternate.should_receive(:main_character).and_return(raid_main)
              general_alternate.should_receive(:raid_alternate).and_return(raid_alternate)

              drop.correctly_assigned?.should be_false
            end
          end
        end
      end

      context "via guild bank" do
        it "should be false" do
          item = mock_model(Item, loot_type: armour)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'g', loot_type: armour)

          drop.correctly_assigned?.should be_false
        end
      end

      context "via trash" do
        it "should return false" do
          item = mock_model(Item, loot_type: armour)
          drop = Drop.new(character: raid_main, item: item, loot_method: 't', loot_type: armour)

          drop.correctly_assigned?.should be_false
        end
      end
    end

    context "when looting a trade skill item" do
      context "via need" do
        it "should return false" do
          item = mock_model(Item, loot_type: trade_skill)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: trade_skill)

          drop.correctly_assigned?.should be_false
        end
      end
      context "via random" do
        it "should return true" do
          item = mock_model(Item, loot_type: trade_skill)
          item.should_receive(:archetypes).and_return([])
          drop = Drop.new(character: raid_main, item: item, loot_method: 'r', loot_type: trade_skill)

          drop.correctly_assigned?.should be_true
        end
      end
      context "via guild bank" do
        it "should return true" do
          item = mock_model(Item, loot_type: trade_skill)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'g', loot_type: trade_skill)

          drop.correctly_assigned?.should be_true
        end
      end
      context "via trash" do
        it "should return false" do
          item = mock_model(Item, loot_type: trade_skill)
          drop = Drop.new(character: raid_main, item: item, loot_method: 't', loot_type: trade_skill)

          drop.correctly_assigned?.should be_false
        end
      end
    end

    context "when looting a spell" do
      context "via need" do
        it "should return false" do
          item = mock_model(Item, loot_type: spell)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: spell)

          drop.correctly_assigned?.should be_false
        end
      end
      context "via random" do
        context "for the right archetype" do
          it "should return true" do
            item = mock_model(Item, loot_type: spell)
            item.should_receive(:archetypes).at_least(2).times.and_return([fighter])
            drop = Drop.new(character: raid_main, item: item, loot_method: 'r', loot_type: spell)

            drop.correctly_assigned?.should be_true
          end
        end
        context "for the wrong archetype" do
          it "should return false" do
            item = mock_model(Item, loot_type: spell)
            item.should_receive(:archetypes).at_least(2).times.and_return([priest])
            drop = Drop.new(character: raid_main, item: item, loot_method: 'r', loot_type: spell)

            drop.correctly_assigned?.should be_false
          end
        end
      end
      context "via guild bank" do
        it "should return true" do
          item = mock_model(Item, loot_type: spell)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'g', loot_type: spell)

          drop.correctly_assigned?.should be_true
        end
      end
      context "via trash" do
        it "should return false" do
          item = mock_model(Item, loot_type: spell)
          drop = Drop.new(character: raid_main, item: item, loot_method: 't', loot_type: spell)

          drop.correctly_assigned?.should be_false
        end
      end
    end

    context "when looting a trash item" do
      context "via need" do
        it "should return false" do
          item = mock_model(Item, loot_type: trash)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'n', loot_type: trash)

          drop.correctly_assigned?.should be_false
        end
      end
      context "via random" do
        it "should return false" do
          item = mock_model(Item, loot_type: trash)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'r', loot_type: trash)

          drop.correctly_assigned?.should be_false
        end
      end
      context "via guild bank" do
        it "should return false" do
          item = mock_model(Item, loot_type: trash)
          drop = Drop.new(character: raid_main, item: item, loot_method: 'g', loot_type: trash)

          drop.correctly_assigned?.should be_false
        end
      end
      context "via trash" do
        it "should return true" do
          item = mock_model(Item, loot_type: trash)
          drop = Drop.new(character: raid_main, item: item, loot_method: 't', loot_type: trash)

          drop.correctly_assigned?.should be_true
        end
      end
    end
  end
end