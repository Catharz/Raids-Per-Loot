class Drop < ActiveRecord::Base
  include LootMethodHelper
  belongs_to :instance, :inverse_of => :drops, :touch => true
  belongs_to :zone, :inverse_of => :drops, :touch => true
  belongs_to :mob, :inverse_of => :drops, :touch => true
  belongs_to :character, :inverse_of => :drops, :touch => true
  belongs_to :item, :inverse_of => :drops, :touch => true
  belongs_to :loot_type, :inverse_of => :drops, :touch => true

  validates_uniqueness_of :drop_time, :scope => [:instance_id, :zone_id, :mob_id, :item_id, :character_id]
  validates_format_of :loot_method, :with => /n|r|b|g|t|m/ # Need, Random, Bid, Guild Bank, Trash, Transmuted

  # If the character received loot via "need", make sure all of the relationships are setup
  with_options :if => :needed do
    validate :relationships_exist
    validates_presence_of :instance_id, :zone_id, :mob_id, :item_id, :character_id, :drop_time, :loot_method
  end

  delegate :name, to: :zone, prefix: :zone
  delegate :name, to: :mob, prefix: :mob
  delegate :name, to: :item, prefix: :item
  delegate :name, to: :character, prefix: :character
  delegate :name, to: :loot_type, prefix: :loot_type, allow_nil: true
  delegate :archetype_name, to: :character, prefix: :character, allow_nil: true

  default_scope select((column_names - %w{chat}).map {|column_name| "#{table_name}.#{column_name}"})

  scope :by_character, ->(character_id) { character_id ? where(character_id: character_id) : scoped }
  scope :by_instance, ->(instance_id) { instance_id ? where(instance_id: instance_id) : scoped }
  scope :by_zone, ->(zone_id) { zone_id ? where(zone_id: zone_id) : scoped }
  scope :by_mob, ->(mob_id) { mob_id ? where(mob_id: mob_id) : scoped }
  scope :by_item, ->(item_id) { item_id ? where(item_id: item_id) : scoped }
  scope :by_log_line, ->(line) { line ? where(log_line:line) : scoped }
  scope :by_eq2_item_id, ->(eq2_item_id) {
    eq2_item_id ? includes(:item).
        where('items.eq2_item_id = ?', eq2_item_id) : scoped
  }
  scope :of_type, ->(loot_type_name) {
    where(:loot_type_id => LootType.find_by_name(loot_type_name).id)
  }
  scope :by_archetype, ->(archetype_name) {
    archetype_name ? includes(:character => :archetype).
        where('archetypes.name = ?', archetype_name) : scoped
  }
  scope :by_player, ->(player_id) {
    player_id ? includes(:character => :player).
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

  def self.invalidly_assigned(options = {:validate_trash => false, :validate_general_alts => false})
    invalid_list = character_missing + mismatched_loot_types + won_by('n').for_wrong_class +
        trash_for_non_trash + main_won_without_need + raid_alt_won_without_random +
        guild_bank_for_non_guild_bank + guild_bank_bad_assignment

    invalid_list += need_on_trash + random_on_trash + bid_on_trash if options[:validate_trash]
    invalid_list += general_alt_won_without_bid if options[:validate_general_alts]
    invalid_list
  end

  def self.character_missing
    where('drops.character_id is null')
  end

  def self.mismatched_loot_types
    joins(:item).where('drops.loot_type_id <> items.loot_type_id')
  end

  def self.need_on_trash
    joins(:item => :loot_type).where(['drops.loot_method = ? and loot_types.default_loot_method = ?', 'n', 't'])
  end

  def self.random_on_trash
    joins(:item => :loot_type).where(['drops.loot_method = ? and loot_types.default_loot_method = ?', 'r', 't'])
  end

  def self.bid_on_trash
    joins(:item => :loot_type).where(['drops.loot_method = ? and loot_types.default_loot_method = ?', 'b', 't'])
  end

  def self.trash_for_non_trash
    joins(:item => :loot_type).where(['drops.loot_method = ? and loot_types.default_loot_method <> ?', 't', 't'])
  end

  def self.guild_bank_for_non_guild_bank
    joins(:item => :loot_type).where(['drops.loot_method = ? and loot_types.default_loot_method <> ?', 'g', 'g'])
  end

  def self.guild_bank_bad_assignment
    joins(:item => :loot_type).where(['drops.loot_method not in (?, ?) and loot_types.default_loot_method = ?', 'r', 'g', 'g'])
  end

  def self.main_won_without_need
    joins(:character => {:player => {:characters => :character_types}}).where('drops.loot_method not in (?)', %w{n g t}).where(['(select ct2.char_type from character_types ct2 where ct2.character_id = drops.character_id and ct2.effective_date = ((select max(ct3.effective_date) from character_types ct3 where ct3.character_id = drops.character_id and ct3.effective_date <= drops.drop_time))) = ?', 'm'])
  end

  def self.raid_alt_won_without_random
    joins(:character => {:player => {:characters => :character_types}}).where('drops.loot_method not in (?)', %w{r g t}).where(['(select ct2.char_type from character_types ct2 where ct2.character_id = drops.character_id and ct2.effective_date = ((select max(ct3.effective_date) from character_types ct3 where ct3.character_id = drops.character_id and ct3.effective_date <= drops.drop_time))) = ?', 'r'])
  end

  def self.general_alt_won_without_bid
    joins(:character => {:player => {:characters => :character_types}}).where('drops.loot_method not in (?)', %w{b g t}).where(['(select ct2.char_type from character_types ct2 where ct2.character_id = drops.character_id and ct2.effective_date = ((select max(ct3.effective_date) from character_types ct3 where ct3.character_id = drops.character_id and ct3.effective_date <= drops.drop_time))) = ?', 'g'])
  end

  def self.old_invalidly_assigned
    all.to_a.select { |d| !d.invalid_reason.nil? }
  end

  def self.with_default_loot_method(default_loot_method)
    joins(:item => :loot_type).where(['loot_types.default_loot_method = ?', default_loot_method])
  end

  def self.needed
    won_by('n')
  end

  def self.won_by(loot_method)
    where(:loot_method => loot_method)
  end

  def self.for_wrong_class
    where('(select c.archetype_id from characters c where c.id = drops.character_id) ' +
              'not in (select ai.archetype_id from archetypes_items ai where ai.item_id = drops.item_id)')
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= 'drop'
    xml_attributes = self.attributes
    xml_attributes.to_xml(to_xml_opts)
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
