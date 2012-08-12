class Drop < ActiveRecord::Base
  belongs_to :instance, :inverse_of => :drops, :touch => true
  belongs_to :zone, :inverse_of => :drops, :touch => true
  belongs_to :mob, :inverse_of => :drops, :touch => true
  belongs_to :character, :inverse_of => :drops, :touch => true
  belongs_to :item, :inverse_of => :drops, :touch => true
  belongs_to :loot_type, :inverse_of => :drops, :touch => true

  validates_uniqueness_of :drop_time, :scope => [:instance_id, :zone_id, :mob_id, :item_id, :character_id]
  validates_format_of :loot_method, :with => /n|r|b|t/ # Need, Random, Bid, Trash

  # If the character received loot via "need", make sure all of the relationships are setup
  with_options :if => :needed do
    validate :relationships_exist
    validates_presence_of :zone_id, :mob_id, :item_id, :character_id, :drop_time, :loot_method
  end

  def loot_method_name
    case self.loot_method
      when "n" then
        "Need"
      when "r" then
        "Random"
      when "b" then
        "Bid"
      when "t" then
        "Trash"
      else
        "Unknown"
    end
  end

  def self.invalidly_assigned
    needed.for_wrong_class
  end

  def self.of_type(loot_type_name)
    where(:loot_type_id => LootType.find_by_name(loot_type_name).id)
  end

  def self.needed
    where(:loot_method => "n")
  end

  def self.for_wrong_class
    where("(select c.archetype_id from characters c where c.id = drops.character_id) " +
              "not in (select ai.archetype_id from archetypes_items ai where ai.item_id = drops.item_id)")
  end

  def invalid_reason
    if character
      case loot_method
        when 'n'
          if item.loot_type and item.loot_type.default_loot_method.eql? 't'
            "Loot via Need for Trash Item"
          else
            if character.char_type.eql? 'm'
              if character.archetype and item.archetypes.include? character.archetype
                nil
              else
                "Item / Character Class Mis-Match"
              end
            else
              "Loot via Need for Non-Raid Main"
            end
          end
        when 'r'
          if item.loot_type and item.loot_type.default_loot_method.eql? 't'
            "Loot via Random on Trash Item"
          else
            if character.char_type.eql? 'r'
              if character.archetype and item.archetypes.include? character.archetype
                nil
              else
                "Item / Character Class Mis-Match"
              end
            else
              "Loot via Random for Non-Raid Alt"
            end
          end
        when 'b'
          if item.loot_type and item.loot_type.default_loot_method.eql? 't'
            "Loot via Bid for Trash Item"
          else
            if character.char_type.eql? 'g'
              unless character.archetype and item.archetypes.include? character.archetype
                "Item / Character Class Mis-Match"
              end
            else
              "Loot via Bid for Non-General Alt"
            end
          end
        else
          unless item.loot_type and item.loot_type.default_loot_method.eql? 't'
            "Loot via Trash for Non-Trash item"
          end
      end
    else
      "No Character for Drop"
    end
  end

  def correctly_assigned?
    invalid_reason.nil?
  end

  def self.by_archetype(archetype_name)
    archetype_name ? eager_load(:character => :archetype).where(['archetypes.name = ?', archetype_name]) : scoped
  end

  def self.by_instance(instance_id)
    instance_id ? where('instance_id = ?', instance_id) : scoped
  end

  def self.by_zone(zone_id)
    zone_id ? where('zone_id = ?', zone_id) : scoped
  end

  def self.by_mob(mob_id)
    mob_id ? where('mob_id = ?', mob_id) : scoped
  end

  def self.by_character(character_id)
    character_id ? where('character_id = ?', character_id) : scoped
  end

  def self.by_player(player_id)
    player_id ? includes(:character => :player).where('characters.player_id = ?', player_id) : scoped
  end

  def self.by_item(item_id)
    item_id ? where('item_id = ?', item_id) : scoped
  end

  def self.by_time(time)
    if time
      drop_time = time.is_a?(String) ? DateTime.parse(time) : time
      where(:drop_time => drop_time)
    else
      scoped
    end
  end

  def utc_time(date_time)
    TZInfo::Timezone.get('Australia/Melbourne').utc_time(date_time)
  end

  def local_time(date_time)
    TZInfo::Timezone.get('Australia/Melbourne').local_time(date_time)
  end

  def loot_type_name
    if self.item
      self.item.loot_type ? self.item.loot_type.name : "Unknown"
    else
      "Unknown"
    end
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "drop"
    xml_attributes = self.attributes
    xml_attributes.to_xml(to_xml_opts)
  end

  protected
  def relationships_exist
    errors.add(:zone_id, "doesn't exist") unless Zone.exists?(zone_id)
    errors.add(:mob_id, "doesn't exist") unless Mob.exists?(mob_id)
    errors.add(:item_id, "doesn't exist") unless Item.exists?(item_id)
    errors.add(:character_id, "doesn't exist") unless Character.exists?(character_id)
    unless loot_type_id.nil?
      errors.add(:loot_type_id, "doesn't exist") unless LootType.exists?(loot_type_id)
    end
  end
end
