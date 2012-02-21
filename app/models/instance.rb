class Instance < ActiveRecord::Base
  belongs_to :instance
  belongs_to :raid
  belongs_to :zone
  has_many :drops
  has_and_belongs_to_many :players
  accepts_nested_attributes_for :players, :drops

  scope :raided, lambda {|raid_date| where(:raid_id => Raid.find_by_raid_date(raid_date).id) }

  def self.find_by_zone_and_time(zone_name, instance_time)
    zone = Zone.find_by_name(zone_name)
    instance = nil
    unless zone.nil?
      instance = Instance.first(
          :conditions => ["zone_id = ? AND start_time <= ? AND end_time >= ?",
              zone.id,
              instance_time,
              instance_time])
    end
    instance
  end

  def self.find_by_time(instance_time)
    result = Instance.first(:conditions => ["start_time <= ? AND end_time >= ?", instance_time, instance_time])
    result
  end
  
  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "instance"
    xml_attributes = self.attributes
    xml_attributes["players"] = self.players
    xml_attributes["drops"] = self.drops
    xml_attributes.to_xml(to_xml_opts)
  end
end
