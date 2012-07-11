class Player < ActiveRecord::Base
  include PointsCalculator

  belongs_to :rank, :inverse_of => :players, :touch => true

  has_many :characters, :inverse_of => :player

  has_one :main_character,
          :class_name => 'Character',
          :conditions => ["characters.char_type = 'm'"]
  has_one :raid_alternate,
          :class_name => 'Character',
          :conditions => ["characters.char_type = 'r'"]
  has_many :general_alternates,
           :class_name => 'Character',
           :conditions => ["characters.char_type = 'g'"]

  has_many :character_instances, :through => :characters
  has_many :instances, :through => :character_instances
  has_many :raids, :through => :instances, :uniq => true
  has_many :drops, :through => :characters
  has_many :items, :through => :drops, :conditions => ["drops.loot_method = ?", "n"]

  has_many :adjustments, :as => :adjustable

  validates_presence_of :name
  validates_presence_of :rank_id
  validates_uniqueness_of :name

  # Don't accept any blank characters
  accepts_nested_attributes_for :characters,
                                :allow_destroy => true,
                                :reject_if => :all_blank

  def with_new_characters(n = 1)
    n.times do
      characters.build
    end
    self
  end

  def self.with_name_like(name)
    name ? where('players.name LIKE ?', "%#{name}%") : scoped
  end

  def self.of_rank(rank_id)
    rank_id ? where(:rank_id => rank_id) : scoped
  end

  def self.by_instance(instance_id)
    instance_id ? includes(:characters => :character_instances).where('character_instances.instance_id = ?', instance_id) : scoped
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "player"
    self.attributes.to_xml(to_xml_opts)
  end

  def to_csv
    CSV.generate_line(
        [self.name,
         self.rank ? self.rank.name : "Unknown",
         self.main_character ? self.main_character.name : "Unknown",
         self.first_raid ? self.first_raid.raid_date : "Never",
         self.last_raid ? self.last_raid.raid_date : "Never",
         self.raids_count,
         self.instances_count,
         self.armour_rate,
         self.jewellery_rate,
         self.weapon_rate
        ])
  end
end