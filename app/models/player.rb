# @author Craig Read
#
# Player represents the Human controlling
# the Character(s) they raid with
class Player < ActiveRecord::Base
  include PointsCalculationHelper
  has_paper_trail

  include ActionView::Helpers::UrlHelper
  delegate :url_helpers, to: 'Rails.application.routes'

  before_save :update_loot_rates

  belongs_to :rank, :inverse_of => :players, :touch => true

  has_many :characters, :inverse_of => :player, dependent: :destroy

  has_many :character_instances, :through => :characters
  has_many :player_raids, inverse_of: :player
  has_many :raids, :through => :player_raids, :uniq => true
  has_many :instances, :through => :raids, :uniq => true
  has_many :drops, :through => :characters
  has_many :items, :through => :drops, :conditions => ['drops.loot_method = ?', 'n']

  has_many :comments, as: :commented, dependent: :destroy

  has_one :current_main, class_name: 'Character', conditions: ['characters.char_type = ?', 'm']
  has_one :current_raid_alternate, class_name: 'Character', conditions: ['characters.char_type = ?', 'r']
  has_many :current_general_alternates, class_name: 'Character', conditions: ['characters.char_type = ?', 'g']

  validates_presence_of :name
  validates_presence_of :rank_id
  validates_uniqueness_of :name
  validates :switches_count, presence: true

  delegate :name, to: :rank, prefix: :rank, allow_nil: true

  delegate :date, to: :first_raid, allow_nil: true
  delegate :date, to: :last_raid, allow_nil: true

  scope :of_rank, ->(rank_id) {
    rank_id ? where(:rank_id => rank_id) : scoped
  }
  scope :by_instance, ->(instance_id) {
    instance_id ? includes(:characters => :character_instances).
        where('character_instances.instance_id = ?', instance_id) : scoped
  }

  def path(options = {})
    link_to name, url_helpers.player_path(self), options
  end

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

  def current_main_name
    current_main ? current_main.name : nil
  end

  def current_raid_alternate_name
    current_raid_alternate ? current_raid_alternate.name : nil
  end

  def update_loot_rates
    totals = characters.select(
        'sum(armour_count) as armour, ' +
            'sum(weapons_count) as weapons, ' +
            'sum(jewellery_count) as jewellery, ' +
            'sum(adornments_count) as adornments, ' +
            'sum(dislodgers_count) as dislodgers, ' +
            'sum(mounts_count) as mounts').first.attributes.with_indifferent_access
    self.armour_count = totals[:armour].to_i
    self.weapons_count = totals[:weapons].to_i
    self.jewellery_count = totals[:jewellery].to_i
    self.adornments_count = totals[:adornments].to_i
    self.dislodgers_count = totals[:dislodgers].to_i
    self.mounts_count = totals[:mounts].to_i
    recalculate_loot_rates(raids_count)
  end

  def to_s
    "#{name} (#{rank_name})"
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
    csv_values = [
        name, rank_name, current_main_name, first_raid_date, last_raid_date, raids_count, instances_count,
        armour_rate, jewellery_rate, weapon_rate, adornment_rate, dislodger_rate, mount_rate, switch_rate]
    CSV.generate_line(csv_values)
  end
end