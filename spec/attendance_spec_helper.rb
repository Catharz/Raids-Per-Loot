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
      character.stub!(:raids).and_return(raid_list)
      character.stub!(:instances).and_return(instance_list)
    end
  end
end