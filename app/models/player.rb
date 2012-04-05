class Player < ActiveRecord::Base
  include PointsCalculator

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

  validates_presence_of :name
  validates_presence_of :rank_id
  validates_uniqueness_of :name

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