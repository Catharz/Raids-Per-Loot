require 'zone_spec_helper'
require 'raid_spec_helper'
require 'instance_spec_helper'

module AttendanceSpecHelper
  include ZoneSpecHelper, RaidSpecHelper, InstanceSpecHelper

  def create_attendance(attendance)
    zone_list = create_zones(attendance[:num_instances])
    raid_list = create_raids(attendance[:num_raids])
    instance_list = create_instances(raid_list, zone_list)

    attendees = attendance[:attendees]

    attendees.each do |character|
      instance_list.each do |instance|
        CharacterInstance.find_or_create_by_character_id_and_instance_id(character.id, instance.id)
      end
    end
  end
end