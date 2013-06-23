require 'csv'

class Character < ActiveRecord::Base
  include RemoteConnectionHelper, PointsCalculationHelper, CharactersHelper

  include ActionView::Helpers::UrlHelper
  delegate :url_helpers, to: 'Rails.application.routes'

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

  validates_presence_of :name
  validates_presence_of :player, :archetype, :char_type, :on => :update

  validates_uniqueness_of :name
  validates_format_of :char_type, :with => /g|m|r/ # General Alt, Main, Raid Alt

  delegate :name, to: :player, prefix: :player, allow_nil: true
  delegate :name, to: :archetype, prefix: :archetype, allow_nil: true
  delegate :name, to: :current_main, prefix: :current_main, allow_nil: true
  delegate :name, to: :current_raid_alternate, prefix: :current_raid_alternate, allow_nil: true
  delegate :raid_date, to: :first_raid, prefix: :first, allow_nil: true
  delegate :raid_date, to: :last_raid, prefix: :last, allow_nil: true

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
      archetype.root ? archetype.root.name : 'Unknown'
    else
      'Unknown'
    end
  end

  def fetch_soe_character_details
    Resque.enqueue(SonyCharacterUpdater, self.id)
  end

  def rank_at_time(time)
    character_types.where('character_types.effective_date <= ?', time).order(:effective_date).last.char_type
  end

  def to_csv
    CSV.generate_line(
        [self.name,
         char_type_name(self.char_type),
         self.main_character ? self.main_character.name : 'Unknown',
         self.archetype ? self.archetype.name : 'Unknown',
         self.first_raid ? self.first_raid.raid_date : 'Never',
         self.last_raid ? self.last_raid.raid_date : 'Never',
         self.raids_count,
         self.instances_count,
         self.armour_rate,
         self.jewellery_rate,
         self.weapon_rate
        ])
  end
end