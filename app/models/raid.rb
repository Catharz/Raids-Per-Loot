require 'raid_validator'

class Raid < ActiveRecord::Base
  has_many :instances

  def raid_description
    raid_date.to_s + ': ' + zone.name
  end

  def zone_name
    if zone
      zone.name
    else
      "Unknown"
    end
  end

  def self.utc_time(date_time)
    TZInfo::Timezone.get('Australia/Melbourne').utc_time(date_time)
  end

  def self.local_time(date_time)
    TZInfo::Timezone.get('Australia/Melbourne').local_time(date_time)
  end
end