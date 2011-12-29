require 'raid_validator'

class Raid < ActiveRecord::Base
  has_many :drops
  belongs_to :zone
  has_and_belongs_to_many :players
  accepts_nested_attributes_for :players, :drops

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
    found_raid = nil
    raid_list = Raid.find_by_time(raid_time)
    raid_list.each do |raid|
      found_raid = raid if raid.zone_name.eql? zone_name
    end
    found_raid
  end

  def self.find_by_time(raid_time)
    result = Array.new
    Raid.find_all_by_raid_date(raid_time.to_date).each do |raid|
      if raid.start_time <= raid_time
        if raid.end_time.nil? or raid.end_time >= raid_time
          result << raid
        end
      end
    end
    result
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "raid"
    xml_attributes = self.attributes
    xml_attributes["players"] = self.players
    xml_attributes["drops"] = self.drops
    xml_attributes.to_xml(to_xml_opts)
  end
end