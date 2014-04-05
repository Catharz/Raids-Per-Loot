require 'spec_helper'

include PointsCalculationHelper

describe PointsCalculationHelper do
  describe '#attendance_for_period' do
    it 'operates based on a date range' do
      char = FactoryGirl.create(:character)
      range = {start: 3.months.ago, end: 1.month.ago}

      expect(char).to receive(:raid_count).with(range, true)
      char.attendance_for_period(range)
    end

    it 'agregates the range only if requested' do
      player = FactoryGirl.create(:player)
      range = {start: 3.months.ago, end: 1.month.ago}

      expect(player).to receive(:raid_count).with(range, false)
      player.attendance_for_period(range, false)
    end

    it 'returns the attendance as a percentage' do
      char = FactoryGirl.create(:character)
      range = {start: 3.months.ago, end: 1.month.ago}

      expect(char).to receive(:raid_count).with(range, true).and_return 5.0
      expect(Raid).to receive(:for_period).with(range).and_return Array.new(10) { stub_model(Raid) }
      expect(char.attendance_for_period(range)).to eq 50.0
    end
  end

  describe '#attendance' do
    it 'calculates a percentage' do
      player = FactoryGirl.create(:player, raids_count: 5)

      expect(Raid).to receive(:count).twice.and_return 10
      expect(player.attendance).to eq 50.0
    end
  end

  describe '#recalculate_loot_rates' do
    context 'calculates' do
      example 'armour rate' do
        char = stub_model(Character)

        expect(char).to receive(:armour_rate=)
        char.recalculate_loot_rates
      end

      example 'jewellery rate' do
        char = stub_model(Character)

        expect(char).to receive(:jewellery_rate=)
        char.recalculate_loot_rates
      end

      example 'weapon rate' do
        char = stub_model(Character)

        expect(char).to receive(:weapon_rate=)
        char.recalculate_loot_rates
      end

      example 'attuned rate' do
        char = stub_model(Character)

        expect(char).to receive(:attuned_rate=)
        char.recalculate_loot_rates
      end

      example 'adornment rate' do
        char = stub_model(Character)

        expect(char).to receive(:adornment_rate=)
        char.recalculate_loot_rates
      end

      example 'dislodger rate' do
        char = stub_model(Character)

        expect(char).to receive(:dislodger_rate=)
        char.recalculate_loot_rates
      end

      example 'mount rate' do
        char = stub_model(Character)

        expect(char).to receive(:mount_rate=)
        char.recalculate_loot_rates
      end

      example 'switch rate' do
        char = stub_model(Character)
        char.stub(:switches_count)

        expect(char).to receive(:switch_rate=)
        char.recalculate_loot_rates
      end
    end
  end

  describe '#raid_count' do
    context 'for a character' do
      it 'counts their players raids' do
        player = FactoryGirl.create(:player)
        char = FactoryGirl.create(:character, player: player)
        raid_list = Raid.scoped
        raid_list.stub(:for_period).and_return(Array.new)

        expect(char).to receive(:player).and_return(player)
        expect(player).to receive(:raids).and_return(raid_list)
        char.raid_count
      end
    end

    context 'for a player' do
      it 'counts their own raids' do
        player = FactoryGirl.create(:player)
        raid_list = Raid.scoped
        raid_list.stub(:for_period).and_return(Array.new)

        expect(player).to receive(:raids).and_return(raid_list)
        player.raid_count
      end
    end


    it 'operates based on a date range' do
      char = FactoryGirl.create(:character)
      range = {start: 3.months.ago, end: 1.month.ago}

      expect(char).to receive(:raid_count).with(range, true)
      char.attendance_for_period(range)
    end

    it 'agregates the range only if requested' do
      player = FactoryGirl.create(:player)
      range = {start: 3.months.ago, end: 1.month.ago}

      expect(player).to receive(:raid_count).with(range, false)
      player.attendance_for_period(range, false)
    end
  end

  describe '#calculate_loot_rate' do
    context 'returns 0.0' do
      it 'for no events' do
        char = FactoryGirl.create(:character)

        expect(char.calculate_loot_rate(nil, 100)).to eq 0.0
      end

      it 'for no items' do
        player = FactoryGirl.create(:player)

        expect(player.calculate_loot_rate(100, nil)).to eq 0.0
      end
    end

    it 'avoids divide by 0 errors' do
      char = FactoryGirl.create(:character)

      expect(char.calculate_loot_rate(10, 0)).to eq 10.0
    end
  end

  describe '#first_drop' do
    it 'gets the first drop based on drop time' do
      char = FactoryGirl.create(:character)
      drop_list = Drop.scoped

      expect(char).to receive(:drops).and_return drop_list
      expect(drop_list).to receive(:order).with('drop_time').and_return drop_list
      expect(drop_list).to receive(:first)
      char.first_drop
    end
  end

  describe '#last_drop' do
    it 'gets the last drop based on drop time' do
      char = FactoryGirl.create(:character)
      drop_list = Drop.scoped

      expect(char).to receive(:drops).and_return drop_list
      expect(drop_list).to receive(:order).with('drop_time desc').and_return drop_list
      expect(drop_list).to receive(:first)
      char.last_drop
    end
  end

  describe '#first_instance' do
    it 'gets the first instance based on start time' do
      char = FactoryGirl.create(:character)
      instance_list = Instance.scoped

      expect(char).to receive(:instances).and_return instance_list
      expect(instance_list).to receive(:order).with('start_time').and_return instance_list
      expect(instance_list).to receive(:first)
      char.first_instance
    end
  end

  describe '#last_instance' do
    it 'gets the last instance based on start time' do
      char = FactoryGirl.create(:character)
      instance_list = Instance.scoped

      expect(char).to receive(:instances).and_return instance_list
      expect(instance_list).to receive(:order).with('start_time desc').and_return instance_list
      expect(instance_list).to receive(:first)
      char.last_instance
    end
  end

  describe '#first_raid' do
    it 'gets the first raid based on raid date' do
      char = FactoryGirl.create(:character)
      raid_list = Raid.scoped

      expect(char).to receive(:raids).and_return raid_list
      expect(raid_list).to receive(:order).with('raid_date').and_return raid_list
      expect(raid_list).to receive(:first)
      char.first_raid
    end
  end

  describe '#last_raid' do
    it 'gets the last raid based on raid date' do
      char = FactoryGirl.create(:character)
      raid_list = Raid.scoped

      expect(char).to receive(:raids).and_return raid_list
      expect(raid_list).to receive(:order).with('raid_date desc').and_return raid_list
      expect(raid_list).to receive(:first)
      char.last_raid
    end
  end
end
