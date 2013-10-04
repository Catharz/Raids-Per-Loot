require 'spec_helper'

describe Instance do
  let(:zone) { FactoryGirl.create(:zone, name: 'Wherever') }
  let(:raid) { FactoryGirl.create(:raid, raid_date: DateTime.parse('2012-01-31'))}

  context 'associations' do
    it { should belong_to(:raid) }
    it { should belong_to(:zone) }

    it { should have_many(:drops).dependent(:destroy) }
    it { should have_many(:character_instances).dependent(:destroy) }

    it { should have_many(:kills).through(:drops) }
    it { should have_many(:characters).through(:character_instances) }
    it { should have_many(:players).through(:characters) }
  end

  context 'validations' do
    it { should validate_presence_of(:raid) }
    it { should validate_presence_of(:zone) }
    it { should validate_presence_of(:start_time) }
  end

  context 'scopes' do
    before(:each) do
      @raids = Array.new(3) do |n|
        raid = FactoryGirl.create(:raid, raid_date: Date.parse('2012-01-01') + n.days)
        Array.new(2) do |o|
          start_time = raid.raid_date + 20.hours + o.hours
          FactoryGirl.create(:instance, raid_id: raid.id, start_time: start_time)
        end
        raid
      end
    end

    describe 'raided' do
      it 'returns instances associated with a raid on a particular raid date' do
        Instance.raided(Date.parse('2012-01-01')).should match_array @raids.first.instances
      end
    end

    describe 'by_raid' do
      it 'returns instances associated with a raid using its id' do
        Instance.by_raid(@raids.last.id).should match_array @raids.last.instances
      end

      it 'returns all instances by default' do
        Instance.by_raid(nil).should match_array Instance.all
      end
    end

    describe 'by_zone' do
      it 'returns instances associated with a zone by using its id' do
        zone_id = @raids[1].instances.first.zone_id
        Instance.by_zone(zone_id).should eq [@raids[1].instances.first]
      end

      it 'returns all instances by default' do
        Instance.by_zone(nil).should match_array Instance.all
      end
    end

    describe 'by_start_time' do
      it 'returns instances started at a particular time' do
        start_time = @raids[1].instances.last.start_time
        Instance.by_start_time(start_time).should eq [@raids[1].instances.last]
      end

      it 'returns all instances by default' do
        Instance.by_start_time(nil).should match_array Instance.all
      end
    end
  end
end