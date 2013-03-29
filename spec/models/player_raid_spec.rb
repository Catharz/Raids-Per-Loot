require 'spec_helper'

describe PlayerRaid do
  context 'associations' do
    it { should belong_to(:raid) }
    it { should belong_to(:player) }
  end

  context 'validations' do
    it { should validate_presence_of(:raid_id) }
    it { should validate_presence_of(:player_id) }
    it { should validate_uniqueness_of(:player_id).scoped_to(:raid_id) }
    it { should allow_value('a').for(:status) }
    it { should allow_value('b').for(:status) }
  end

  context 'delegations' do
    it { should delegate_method(:raid_description).to(:raid).as(:description) }
    it { should delegate_method(:player_name).to(:player).as(:name) }
  end

  context 'scopes' do
    let(:progression) { FactoryGirl.create(:raid_type, name: 'Progression') }
    let(:player1) { FactoryGirl.create(:player) }
    let(:player2) { FactoryGirl.create(:player) }
    let(:first_raid) { FactoryGirl.create(:raid, raid_date: Date.today - 60.days, raid_type_id: progression.id) }
    let(:second_raid) { FactoryGirl.create(:raid, raid_date: Date.today - 30.days, raid_type_id: progression.id) }

    let(:pr1) { FactoryGirl.create(:player_raid, player: player1, raid: first_raid) }
    let(:pr2) { FactoryGirl.create(:player_raid, player: player1, raid: second_raid) }
    let(:pr3) { FactoryGirl.create(:player_raid, player: player2, raid: second_raid) }

    describe 'self#by_raid' do
      it 'should show all by default' do
        PlayerRaid.by_raid.should eq [pr1, pr2, pr3]
      end

      it 'should filter by raid_id' do
        PlayerRaid.by_raid(second_raid.id).order(:id).should eq [pr2, pr3]
      end
    end

    describe 'self#by_player' do
      it 'should show all by default' do
        PlayerRaid.by_player.should eq [pr1, pr2, pr3]
      end

      it 'should filter by player_id' do
        PlayerRaid.by_player(player1.id).should eq [pr1]
      end
    end
  end

  describe '#status_description' do
    it "returns 'Attended' when 'a'" do
      pr = FactoryGirl.create(:player_raid, status: 'a')

      pr.status_description.should eq 'Attended'
    end

    it "returns 'Benched' when 'b'" do
      pr = FactoryGirl.create(:player_raid, status: 'b')

      pr.status_description.should eq 'Benched'
    end
  end
end