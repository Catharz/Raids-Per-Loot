class Character < ActiveRecord::Base
  include PointsCalculator

  belongs_to :player
  belongs_to :rank
  belongs_to :archetype

  has_many :drops
  has_many :items, :through => :drops, :conditions => ["assigned_to_character = ?", true]
  has_many :character_instances
  has_many :instances, :through => :character_instances
  has_many :raids, :through => :instances, :uniq => true
  has_many :character_types

  validates_presence_of :name
  validates_uniqueness_of :name

  def char_type
    character_types.order('effective_date desc').first
  end

  def archetype_root
    if archetype
      archetype.root ? archetype.root.name : "Unknown"
    else
      "Unknown"
    end
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