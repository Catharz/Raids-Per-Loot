require 'spec_helper'

describe RaidType do
  context 'associations' do
    it { should have_many(:raids) }
    it { should have_many(:instances).through(:raids) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  context 'filter' do
    let(:pickup) { FactoryGirl.create(:raid_type, name: 'Pickup') }
    let(:progression) { FactoryGirl.create(:raid_type, name: 'Progression')}

    describe 'self #by_name' do
      it 'shows all by default' do
        RaidType.by_name.should eq([pickup, progression])
      end

      it 'filters by name' do
        RaidType.by_name('Pickup').should eq([pickup])
      end
    end
  end
end
