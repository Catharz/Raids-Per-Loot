require 'raid_validator'

class Raid < ActiveRecord::Base
  has_many :drops
  belongs_to :zone
  has_and_belongs_to_many :players

  validates_with RaidValidator

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

  def self.find_by_zone_and_time(zone_name, raid_time)
    raid = Raid.find_by_time(raid_time)
    if raid and raid.zone_name == zone_name
      raid
    end
  end

  def self.find_by_time(raid_time)
    result = nil
    Raid.find_all_by_raid_date(raid_time.to_date).each do |raid|
      if raid.start_time <= raid_time
        if raid.end_time >= raid_time or raid.end_time.nil?
          result = raid
          break
        end
      end
    end
    result
  end
end