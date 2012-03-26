class Mob < ActiveRecord::Base
  belongs_to :zone
  belongs_to :difficulty
  has_many :drops
  has_one :last_drop,
      :class_name => 'Drop',
      :order => 'drops.drop_time desc'

  validates_presence_of :name

  def kills
    num_kills = 0
    Instance.where(:zone_id => zone_id).each do |instance|
      num_kills += 1 if instance.kills.include? self
    end
    num_kills
  end

  def self.by_zone(zone_id)
    zone_id ? where('zone_id = ?', zone_id) : scoped
  end

  def self.by_zone_name(zone_name)
    zone_name ? where('zone_id = ?', Zone.where('name = ?', zone_name).first.id) : scoped
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
