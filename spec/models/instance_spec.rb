require 'spec_helper'

describe Instance do
  let(:zone) { FactoryGirl.create(:zone, name: 'Wherever') }
  let(:raid) { FactoryGirl.create(:raid, raid_date: DateTime.parse("2012-01-31"))}

  context "associations" do
    it { should belong_to(:raid) }
    it { should belong_to(:zone) }

    it { should have_many(:drops).dependent(:destroy) }
    it { should have_many(:character_instances).dependent(:destroy) }

    it { should have_many(:kills).through(:drops) }
    it { should have_many(:characters).through(:character_instances) }
    it { should have_many(:players).through(:characters) }
  end

  context "validations" do
    it { should validate_presence_of(:raid) }
    it { should validate_presence_of(:zone) }
    it { should validate_presence_of(:start_time) }
  end

  context "delegations" do
    it { should delegate_method(:zone_name).to(:zone).as(:name) }
    it { should delegate_method(:raid_date).to(:raid) }
  end
end