class Player < ActiveRecord::Base
  include PointsCalculationHelper

  belongs_to :rank, :inverse_of => :players, :touch => true

  has_many :characters, :inverse_of => :player, dependent: :destroy

  has_many :character_instances, :through => :characters
  has_many :player_raids, inverse_of: :player
  has_many :raids, :through => :player_raids, :uniq => true
  has_many :instances, :through => :raids, :uniq => true
  has_many :drops, :through => :characters
  has_many :items, :through => :drops, :conditions => ['drops.loot_method = ?', 'n']

  has_many :adjustments, :as => :adjustable

  has_one :current_main, class_name: 'Character', conditions: ['characters.char_type = ?', 'm']
  has_one :current_raid_alternate, class_name: 'Character', conditions: ['characters.char_type = ?', 'r']
  has_many :current_general_alternates, class_name: 'Character', conditions: ['characters.char_type = ?', 'g']

  validates_presence_of :name
  validates_presence_of :rank_id
  validates_uniqueness_of :name

  # Don't accept any blank characters
  accepts_nested_attributes_for :characters,
                                :allow_destroy => true,
                                :reject_if => :all_blank

  delegate :name, to: :rank, prefix: :rank, allow_nil: true

  scope :with_name_like, ->(name) {
    name ? where('players.name LIKE ?', "%#{name}%") : scoped
  }
  scope :of_rank, ->(rank_id) {
    rank_id ? where(:rank_id => rank_id) : scoped
  }
  scope :by_instance, ->(instance_id) {
    instance_id ? includes(:characters => :character_instances).
        where('character_instances.instance_id = ?', instance_id) : scoped
  }

  def main_character(at_time = nil)
    characters_of_type('m', at_time).first || NullCharacter.new
  end

  def raid_alternate(at_time = nil)
    characters_of_type('r', at_time).first || NullCharacter.new
  end

  def general_alternates(at_time = nil)
    characters_of_type('g', at_time)
  end

  def characters_of_type(char_type, at_time = nil)
    results = characters.eager_load(:character_types).where(['character_types.char_type = ?', char_type])
    results = results.where(['character_types.effective_date <= ?', at_time]) if at_time
    results.order('character_types.effective_date desc')
  end

  def with_new_characters(n = 1)
    n.times do
      characters.build
    end
    self
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= 'player'
    self.attributes.to_xml(to_xml_opts)
  end

  def to_csv
    CSV.generate_line(
        [self.name,
         self.rank ? self.rank.name : 'Unknown',
         self.main_character ? self.main_character.name : 'Unknown',
         self.first_raid ? self.first_raid.raid_date : nil,
         self.last_raid ? self.last_raid.raid_date : nil,
         self.raids_count,
         self.instances_count,
         self.armour_rate,
         self.jewellery_rate,
         self.weapon_rate
        ])
  end
end