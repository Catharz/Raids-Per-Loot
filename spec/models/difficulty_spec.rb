require 'spec_helper'

describe Difficulty do
  context "associations" do
    it { should have_many(:mobs) }
    it { should have_many(:zones) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:rating) }
  end
end