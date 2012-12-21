require 'spec_helper'

describe RaidType do
  context "associations" do
    it { should have_many(:raids) }
    it { should have_many(:instances).through(:raids) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
  end
end
