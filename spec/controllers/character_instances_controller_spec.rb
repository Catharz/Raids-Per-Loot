require 'spec_helper'

describe CharacterInstancesController do
  fixtures :users

  before(:each) do
    login_as :quentin

    @char1 = FactoryGirl.create(:character, :name => 'character 1')
    @char2 = FactoryGirl.create(:character, :name => 'character 2')

    raid = FactoryGirl.create(:raid, :raid_date => Date.parse("01/07/2012"))
    @inst1 = FactoryGirl.create(:instance, :raid_id => raid.id, :start_time => DateTime.parse("01/07/2012 18:00"))
    @inst2 = FactoryGirl.create(:instance, :raid_id => raid.id, :start_time => DateTime.parse("01/07/2012 20:00"))
  end

  describe "GET index" do
    it "should filter by instance when getting json" do
      ci1 = FactoryGirl.create(:character_instance, :character_id => @char1.id, :instance_id => @inst1.id)
      ci2 = FactoryGirl.create(:character_instance, :character_id => @char2.id, :instance_id => @inst2.id)

      get :index, :format => :json, :instance_id => @inst1.id

      parsed_result = JSON.parse(response.body)
      parsed_result.count.should eq 1
      parsed_result[0]["character_instance"]["id"].should eq ci1.id
      parsed_result[0]["character_instance"]["character_id"].should eq @char1.id
      parsed_result[0]["character_instance"]["instance_id"].should eq @inst1.id
    end

    it "should filter by character when getting json" do
      ci1 = FactoryGirl.create(:character_instance, :character_id => @char1.id, :instance_id => @inst1.id)
      ci2 = FactoryGirl.create(:character_instance, :character_id => @char2.id, :instance_id => @inst2.id)

      get :index, :format => :json, :character_id => @char2.id

      parsed_result = JSON.parse(response.body)
      parsed_result.count.should eq 1
      parsed_result[0]["character_instance"]["id"].should eq ci2.id
      parsed_result[0]["character_instance"]["character_id"].should eq @char2.id
      parsed_result[0]["character_instance"]["instance_id"].should eq @inst2.id
    end
  end

end