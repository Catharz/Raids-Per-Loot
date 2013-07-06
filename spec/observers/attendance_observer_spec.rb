require 'spec_helper'
require 'character_spec_helper'

describe AttendanceObserver do
  include CharacterSpecHelper
  subject { AttendanceObserver.instance }

  it "updates the number of character raids" do
    character = Character.create(valid_character_attributes(:name => "char 1"))
    progression = RaidType.create(name: "Progression")
    raid = Raid.create(:raid_date => "01/01/2012", raid_type: progression)
    zone = Zone.create(:name => 'Anywhere')
    instance = Instance.create(:raid_id => raid.id,
                               :zone_id => zone.id,
                               :start_time => raid.raid_date + 18.hours)
    CharacterInstance.create(:instance => instance, :character => character)

    subject.before_save(character)
    character.raids_count.should eq(1)
  end

  it "updates the number of character instances" do
    character = Character.create(valid_character_attributes(:name => "char2"))
    progression = RaidType.create(name: "Progression")
    raid = Raid.create(:raid_date => "02/01/2012", raid_type: progression)
    zone = Zone.create(:name => 'Anywhere')
    instance1 = Instance.create(:raid_id => raid.id,
                                :zone_id => zone.id,
                               :start_time => raid.raid_date + 18.hours)
    instance2 = Instance.create(:raid_id => raid.id,
                                :zone_id => zone.id,
                               :start_time => raid.raid_date + 20.hours)
    CharacterInstance.create(:instance => instance1, :character => character)
    CharacterInstance.create(:instance => instance2, :character => character)

    subject.before_save(character)
    character.instances_count.should eq(2)
  end
end