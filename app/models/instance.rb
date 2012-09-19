class Instance < ActiveRecord::Base
  belongs_to :raid, :inverse_of => :instances, :touch => true
  belongs_to :zone, :inverse_of => :instances, :touch => true

  has_many :drops, :inverse_of => :instance
  has_many :character_instances, :inverse_of => :instance

  has_many :kills, :through => :drops, :source => :mob, :uniq => true
  has_many :players, :through => :characters, :uniq => true
  has_many :characters, :through => :character_instances

  has_one :last_drop,
      :class_name => 'Drop',
      :order => 'created_at desc'

  accepts_nested_attributes_for :character_instances, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :drops, :reject_if => :all_blank, :allow_destroy => true
  validates_uniqueness_of :start_time, :scope => [:raid_id, :zone_id]

  scope :raided, lambda {|raid_date| where(:raid_id => Raid.find_by_raid_date(raid_date).id) }

  def zone_name
    zone ? zone.name : "Unknown"
  end

  def self.by_raid(raid_id)
    raid_id ? where('raid_id = ?', raid_id) : scoped
  end

  def self.by_zone(zone_id)
    zone_id ? where('zone_id = ?', zone_id) : scoped
  end

  def self.by_start_time(time)
    if time
      start_time = time.is_a?(String) ? DateTime.parse(time) : time
      where(:start_time => start_time)
    else
      scoped
    end
  end

  def self.at_time(time)
    if time
      start_time = time.is_a?(String) ? DateTime.parse(time) : time
      where('start_time <= ?', start_time).last
    else
      scoped.last
    end
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
