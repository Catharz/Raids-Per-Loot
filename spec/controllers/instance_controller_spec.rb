require 'spec_helper'

describe InstancesController do
  before(:each) do
    @raid_date = Date.new(2012, 11, 20)
    @raid = FactoryGirl.create(:raid, :raid_date => @raid_date)
    @zone = FactoryGirl.create(:zone, :name => 'Wherever')
  end

  def valid_attributes
    {:raid_id => @raid.id, :zone_id => @zone.id, :start_time => @raid_date + 20.hours}
  end

  it "filters by zone" do
    Instance.create(valid_attributes)
    zone2 = FactoryGirl.create(:zone, :name => 'Somewhere Else')
    instance2 = Instance.create(valid_attributes.merge!(:start_time => @raid_date + 21.hours, :zone_id => zone2.id))

    get :index, :zone_id => zone2.id
    assigns(:instances).should eq [instance2]
  end

  it "filters by start time" do
    Instance.create(valid_attributes)
    instance2 = Instance.create(valid_attributes.merge!(:start_time => @raid_date + 21.hours))

    get :index, :start_time => DateTime.parse("2012-11-20 10:00:00")
    assigns(:instances).should eq [instance2]
  end

  it "filters by raid" do
    Instance.create(valid_attributes)
    raid2 = FactoryGirl.create(:raid, :raid_date => Date.parse("2012-11-21"))
    instance2 = Instance.create(valid_attributes.merge!(:start_time => raid2.raid_date + 21.hours, :raid_id => raid2.id))

    get :index, :raid_id => raid2.id
    assigns(:instances).should eq [instance2]
  end
end