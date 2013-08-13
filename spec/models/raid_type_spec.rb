require 'spec_helper'

describe RaidType do
  fixtures :raid_types

  context 'associations' do
    it { should have_many(:raids) }
    it { should have_many(:instances).through(:raids) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  context 'filter' do
    let(:newbie) { FactoryGirl.create(:raid_type, name: 'Newbie') }
    let(:fail_whale) { FactoryGirl.create(:raid_type, name: 'Fail Whale')}

    describe 'self #by_name' do
      it 'shows all by default' do
        RaidType.by_name.should include newbie
        RaidType.by_name.should include fail_whale
      end

      it 'filters by name' do
        RaidType.by_name('Newbie').should eq([newbie])
      end
    end
  end
end
