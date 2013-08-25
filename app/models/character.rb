require 'csv'

class Character < ActiveRecord::Base
  include RemoteConnectionHelper, PointsCalculationHelper, CharactersHelper
  has_paper_trail

  include ActionView::Helpers::UrlHelper
  delegate :url_helpers, to: 'Rails.application.routes'

  before_save :update_loot_rates

  belongs_to :player, :inverse_of => :characters, :touch => true
  belongs_to :archetype, :inverse_of => :characters, :touch => true

  has_many :drops, :inverse_of => :character
  has_many :character_instances, :inverse_of => :character, dependent: :destroy
  has_many :character_types, :inverse_of => :character, :dependent => :destroy

  has_one :last_switch, :class_name => 'CharacterType', :order => 'updated_at desc'

  has_many :characters, through: :player
  has_one :current_main, through: :player
  has_one :current_raid_alternate, through: :player
  has_many :current_general_alternates, through: :player

  has_many :items, :through => :drops, :conditions => ['drops.loot_method = ?', 'n']
  has_many :instances, :through => :character_instances
  has_many :raids, :through => :instances, :uniq => true

  has_many :adjustments, :as => :adjustable, :dependent => :destroy
  has_one :external_data, :as => :retrievable, :dependent => :destroy
  has_many :comments, as: :commented, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :player, :archetype, :char_type, :on => :update

  validates_uniqueness_of :name
  validates_format_of :char_type, :with => /g|m|r/ # General Alt, Main, Raid Alt
  validate :must_have_rating_with_date

  delegate :name, to: :player, prefix: :player, allow_nil: true
  delegate :raids_count, to: :player, prefix: :player, allow_nil: true
  delegate :name, to: :archetype, prefix: :archetype, allow_nil: true
  delegate :name, to: :current_main, prefix: :current_main, allow_nil: true
  delegate :name, to: :current_raid_alternate, prefix: :current_raid_alternate, allow_nil: true
  delegate :raid_date, to: :first_raid, prefix: :first, allow_nil: true
  delegate :raid_date, to: :last_raid, prefix: :last, allow_nil: true
  delegate :active, to: :player, prefix: :player, allow_nil: true
  delegate :switches_count, to: :player, prefix: :player, allow_nil: true
  delegate :switch_rate, to: :player, prefix: :player, allow_nil: true

  scope :by_name, ->(name) {
    name ? where(:name => name) : scoped
  }
  scope :by_instance, ->(instance_id) {
    instance_id ? includes(:character_instances).
        where('character_instances.instance_id = ?', instance_id) : scoped
  }
  scope :by_player, ->(player_id) {
    player_id ? where(:player_id => player_id) : scoped
  }
  scope :find_by_archetype, ->(archetype) {
    Character.includes(:archetype).where('archetype_id IN (?)', archetype.descendants([archetype]).collect { |a| a.id }.uniq )
  }
  scope :by_char_type, ->(char_type) {
    char_type ? Character.where(char_type: char_type) : scoped
  }

  def path(options = {})
    link_to name, url_helpers.character_path(self), options
  end

  def html_id
    "character_#{self.id}"
  end

  def main_character(at_time = nil)
    if player
      player.main_character(at_time)
    else
      char_type == 'm' ? self : NullCharacter.new
    end
  end

  def raid_alternate(at_time = nil)
    if player
      player.raid_alternate(at_time)
    else
      char_type == 'r' ? self : NullCharacter.new
    end
  end

  def general_alternates(at_time = nil)
    if player
      player.general_alternates(at_time)
    else
      char_type == 'g' ? [self] : []
    end
  end

  def archetype_root
    if archetype
      archetype.root_name || 'Unknown'
    else
      'Unknown'
    end
  end

  def rank_at_time(time)
    character_types.where('character_types.effective_date <= ?', time).order(:effective_date).last.char_type
  end

  # This is done from the player, as it will update all the characters using update_column
  def update_loot_rates
    self.armour_rate = calculate_loot_rate(player_raids_count, self.armour_count)
    self.jewellery_rate = calculate_loot_rate(player_raids_count, self.jewellery_count)
    self.weapon_rate = calculate_loot_rate(player_raids_count, self.weapons_count)
    self.attuned_rate = calculate_loot_rate(player_raids_count, self.armour_count + self.jewellery_count + self.weapons_count)
    self.adornment_rate = calculate_loot_rate(player_raids_count, self.adornments_count)
    self.dislodger_rate = calculate_loot_rate(player_raids_count, self.dislodgers_count)
    self.mount_rate = calculate_loot_rate(player_raids_count, self.mounts_count)
  end

  def must_have_rating_with_date
    if confirmed_rating.nil? or confirmed_rating.blank?
      errors.add(:base, 'Must select a rating if you enter a confirmed date') unless confirmed_date.nil?
    else
      errors.add(:base, 'Must enter a confirmed date if you select a confirmed rating') if confirmed_date.nil?
    end
  end

  def to_s
    "#{name} (#{archetype_name})"
  end

  def to_csv
    CSV.generate_line(
        [self.name,
         char_type_name(self.char_type),
         self.current_main_name,
         self.archetype_name,
         self.first_raid_date,
         self.last_raid_date,
         self.raids_count,
         self.instances_count,
         self.armour_rate,
         self.jewellery_rate,
         self.weapon_rate,
         self.adornments_count,
         self.adornment_rate,
         self.dislodgers_count,
         self.dislodger_rate,
         self.mounts_count,
         self.mount_rate,
         self.player_switches_count,
         self.player_switch_rate
        ])
  end
end