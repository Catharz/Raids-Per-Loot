class Player < ActiveRecord::Base
  belongs_to :rank

  has_many :characters
  has_one :main_character,
          :class_name => 'Character',
          :conditions => ["char_type = 'm'"]
  has_one :raid_alternate,
          :class_name => 'Character',
          :conditions => ["char_type = 'r'"]
  has_many :general_alternates,
           :class_name => 'Character',
           :conditions => ["char_type = 'g'"]

  has_many :characters
  has_many :character_instances, :through => :characters
  has_many :instances, :through => :character_instances
  has_many :raids, :through => :instances, :uniq => true

  has_many :drops, :through => :characters
  has_many :items, :through => :drops, :conditions => ["assigned_to_character = ?", true]

  has_one :last_drop,
      :class_name => 'Drop',
      :order => 'created_at desc'

  validates_presence_of :name
  validates_presence_of :rank_id
  validates_uniqueness_of :name

  def loot_rate(loot_type)
    calculate_loot_rate(raids.count, items.of_type(loot_type).count)
  end

  def calculate_loot_rate(event_count, item_count)
    (Float(event_count) / (Float(item_count) + 1.0) * 100.00).round / 100.00
  end

  def self.with_name_like(name)
    name ? where('players.name LIKE ?', "%#{name}%") : scoped
  end

  def self.of_rank(rank_id)
    rank_id ? where(:rank_id => rank_id) : scoped
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "player"
    self.attributes.to_xml(to_xml_opts)
  end
end