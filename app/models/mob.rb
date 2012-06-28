class Mob < ActiveRecord::Base
  belongs_to :zone, :inverse_of => :mobs, :touch => true
  belongs_to :difficulty, :inverse_of => :mobs, :touch => true
  has_many :drops, :inverse_of => :mob
  has_many :items, :through => :drops, :uniq => true

  has_one :last_drop,
      :class_name => 'Drop',
      :order => 'created_at desc'

  validates_presence_of :name

  def kills
    num_kills = 0
    Instance.by_zone(zone_id).each do |instance|
      num_kills += 1 if instance.kills.include? self
    end
    num_kills
  end

  def progression
    progression = true
    unless difficulty.nil?
      progression =
          case difficulty.rating
            when 1 # Easy
              false
            when 2 # Normal
              kills < 10
            else   # Hard
              kills < 20
          end
    end
    progression
  end

  def self.by_zone(zone_id)
    zone_id ? where(:zone_id => zone_id) : scoped
  end

  def self.by_zone_name(zone_name)
    zone_name ? where('zone_id = ?', Zone.where('name = ?', zone_name).first.id) : scoped
  end

  def self.by_name(name)
    name ? where(:name => name) : scoped
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
