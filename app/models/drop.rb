require 'drop_assignment_validator'

# @author Craig Read
#
# Drop represents the instance of a character looting an item on a raid
class Drop < ActiveRecord::Base
  include LootMethodHelper
  has_paper_trail

  belongs_to :instance, :inverse_of => :drops, :touch => true
  belongs_to :zone, :inverse_of => :drops, :touch => true
  belongs_to :mob, :inverse_of => :drops, :touch => true
  belongs_to :character, :inverse_of => :drops, :touch => true
  belongs_to :item, :inverse_of => :drops, :touch => true
  belongs_to :loot_type, :inverse_of => :drops, :touch => true

  validates_uniqueness_of :drop_time, :scope => [:instance_id, :zone_id, :mob_id, :item_id, :character_id]
  validates_format_of :loot_method, :with => /\An|r|b|g|t|m\z/ # Need, Random, Bid, Guild Bank, Trash, Transmuted

  # If the character received loot via "need", make sure all of the relationships are setup
  with_options :if => :needed do
    validate :relationships_exist
    validates_presence_of :instance_id, :zone_id, :mob_id, :item_id, :character_id, :drop_time, :loot_method
  end

  delegate :name, to: :zone, prefix: :zone
  delegate :name, to: :mob, prefix: :mob
  delegate :name, to: :item, prefix: :item
  delegate :eq2_item_id, to: :item
  delegate :player, to: :character, allow_nil: true
  delegate :name, to: :character, prefix: :character, allow_nil: true
  delegate :name, to: :loot_type, prefix: :loot_type, allow_nil: true
  delegate :archetype_name, to: :character, prefix: :character, allow_nil: true

  default_scope select((column_names - %w{chat}).map { |column_name| "#{table_name}.#{column_name}" })

  scope :by_character, ->(character_id) { character_id ? where(character_id: character_id) : scoped }
  scope :by_instance, ->(instance_id) { instance_id ? where(instance_id: instance_id) : scoped }
  scope :by_zone, ->(zone_id) { zone_id ? where(zone_id: zone_id) : scoped }
  scope :by_mob, ->(mob_id) { mob_id ? where(mob_id: mob_id) : scoped }
  scope :by_item, ->(item_id) { item_id ? where(item_id: item_id) : scoped }
  scope :by_log_line, ->(line) { line ? where(log_line: line) : scoped }
  scope :by_eq2_item_id, ->(eq2_item_id) {
    eq2_item_id ? joins(:item).
        where('items.eq2_item_id = ?', eq2_item_id) : scoped
  }
  scope :of_type, ->(loot_type_name) {
    joins(:loot_type).where('loot_types.name = ?', loot_type_name)
  }
  scope :by_archetype, ->(archetype_name) {
    archetype_name ? joins(:character => :archetype).
        where('archetypes.name = ?', archetype_name) : scoped
  }
  scope :by_player, ->(player_id) {
    player_id ? joins(:character => :player).
        where('characters.player_id = ?', player_id) : scoped
  }
  scope :by_time, ->(time) {
    if time
      drop_time = time.is_a?(String) ? Time.zone.parse(time) : time
      where(:drop_time => drop_time)
    else
      scoped
    end
  }

  # scopes to support validation
  scope :won_by, ->(loot_method) {
    loot_method.is_a?(Array) ?
        where('loot_method in (?)', loot_method) :
        where(loot_method: loot_method)
  }
  scope :not_won_by, ->(loot_method) {
    loot_method.is_a?(Array) ?
        where('loot_method not in (?)', loot_method) :
        where('loot_method <> ?', loot_method)
  }
  scope :by_character_type, ->(character_type) {
    if character_type.is_a? Array
      joins{character}.where{{character.char_type.in => character_type}}
    else
      joins{character}.where{{character.char_type => character_type}}
    end
  }
  scope :with_default_loot_method, ->(loot_method) {
    if loot_method.is_a? Array
      joins(:item => :loot_type).
          where('loot_types.default_loot_method in (?)', loot_method)
    else
      joins(:item => :loot_type).
          where('loot_types.default_loot_method = ?', loot_method)
    end
  }

  scope :mismatched_loot_types, ->() { joins(:item).where('drops.loot_type_id <> items.loot_type_id') }
  scope :invalid_need_assignment, ->() { won_by('n').by_character_type('g') }
  scope :invalid_guild_bank_assignment, ->() { not_won_by(%w{g r}).with_default_loot_method('g') }
  scope :invalid_trash_assignment, ->() {
    not_won_by('t').with_default_loot_method('t') +
        won_by('t').with_default_loot_method(%w{b n r})
  }
  scope :invalidly_assigned, ->(validate_trash = false) {
    invalid_list = mismatched_loot_types +
        invalid_need_assignment +
        invalid_guild_bank_assignment

    invalid_list += invalid_trash_assignment if validate_trash
    invalid_list
  }

  def loot_method_name
    loot_method_description loot_method
  end

  def assignment_issues
    @assignment_issues ||= DropAssignmentValidator.new(self).validate
  end

  def invalid_reason
    assignment_issues.empty? ? '' : assignment_issues.join(', ')
  end

  def correctly_assigned?
    assignment_issues.empty?
  end

  def to_s
    "#{item_name} looted by #{character_name} on #{drop_time} in #{zone_name}"
  end

  protected
  def relationships_exist
    errors.add(:instance_id, "doesn't exist") unless Instance.exists?(instance_id)
    errors.add(:zone_id, "doesn't exist") unless Zone.exists?(zone_id)
    errors.add(:mob_id, "doesn't exist") unless Mob.exists?(mob_id)
    errors.add(:item_id, "doesn't exist") unless Item.exists?(item_id)
    errors.add(:character_id, "doesn't exist") unless Character.exists?(character_id)
    unless loot_type_id.nil?
      errors.add(:loot_type_id, "doesn't exist") unless LootType.exists?(loot_type_id)
    end
  end
end
