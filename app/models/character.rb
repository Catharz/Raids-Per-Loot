class Character < ActiveRecord::Base
  belongs_to :player
  belongs_to :rank
  belongs_to :archetype

  has_many :drops
  has_many :items, :through => :drops, :conditions => ["assigned_to_player = ?", true]
  has_many :character_instances
  has_many :instances, :through => :character_instances
  has_many :raids, :through => :player, :uniq => true

  has_one :last_drop,
      :class_name => 'Drop',
      :order => 'created_at desc'

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :char_type, :with => /g|m|r/ # General Alt, Main, Raid Alt

  def archetype_root
    if archetype
      archetype.root ? archetype.root.name : "Unknown"
    else
      "Unknown"
    end
  end

  def loot_rate(loot_type)
    calculate_loot_rate(raids.count, items.of_type(loot_type).count)
  end

  def calculate_loot_rate(event_count, item_count)
    (Float(event_count) / (Float(item_count) + 1.0) * 100.00).round / 100.00
  end

  def self.by_instance(instance_id)
    instance_id ? where('character_instances.instance_id = ?', instance_id) : scoped
  end

  def self.by_player(player_id)
    player_id ? where(:player_id => player_id) : scoped
  end

  def self.find_by_archetype(archetype)
    all_characters = Array.new
    Archetype.family(archetype).each do |child_archetype|
      all_characters << Character.all(:conditions => ['archetype_id = ?', child_archetype.id], :order => :name).flatten
    end
    all_characters.flatten.uniq
  end
end