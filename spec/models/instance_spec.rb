require 'spec_helper'

describe Instance do
  let(:zone) { FactoryGirl.create(:zone, name: 'Wherever') }

  describe "#zone_name" do
    it "should return the zone name when it has a zone" do
      instance = FactoryGirl.create(:instance, zone_id: zone.id)

      instance.zone_name.should eq 'Wherever'
    end

    it "should return Unknown when it has no zone" do
      instance = FactoryGirl.create(:instance, zone_id: nil)

      instance.zone_name.should eq 'Unknown'
    end
  end
end