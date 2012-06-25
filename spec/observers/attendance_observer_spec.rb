require 'spec_helper'
require 'character_spec_helper'

describe AttendanceObserver do
  include CharacterSpecHelper

  it "updates the number of character raids" do
    character = Character.create(valid_character_attributes(:name => "char 1"))
    raid = Raid.create(:raid_date => "01/01/2012")
    instance = Instance.create(:raid_id => raid.id,
                               :start_time => raid.raid_date + 18.hours)
    CharacterInstance.create(:instance => instance, :character => character)

    character.raids_count.should eq(1)
  end

  it "updates the number of character instances" do
    character = Character.create(valid_character_attributes(:name => "char2"))
    raid = Raid.create(:raid_date => "02/01/2012")
    instance1 = Instance.create(:raid_id => raid.id,
                               :start_time => raid.raid_date + 18.hours)
    instance2 = Instance.create(:raid_id => raid.id,
                               :start_time => raid.raid_date + 20.hours)
    CharacterInstance.create(:instance => instance1, :character => character)
    CharacterInstance.create(:instance => instance2, :character => character)

    character.instances_count.should eq(2)
  end
end