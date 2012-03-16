class Mob < ActiveRecord::Base
  has_and_belongs_to_many :zones, :join_table => "zones_mobs"
  has_many :drops
  validates_presence_of :name

  def zone_names
    result = "<table>"
    zones.each do |zone|
      result += "<tr><td>" + zone.name + "</td></tr>"
    end
    result + "</table>"
  end

  def self.find_by_zone_and_mob_name(zone_name, mob_name)
    found_mob = nil
    Mob.find_all_by_name(mob_name).each do |mob|
      mob.zones.each do |zone|
        found_mob ||= mob if zone.name.eql? zone_name
      end
    end
    found_mob
  end

  def self.by_zone(zone_id)
    zone_id ? zones.where('id = ?', zone_id) : scoped
  end

  def self.by_zone_name(zone_name)
    zone_name ? zones.where('name = ?', zone_name) : scoped
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "mob"
    self.attributes.to_xml(to_xml_opts)
  end
end
