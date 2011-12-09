class Player < ActiveRecord::Base
  has_many :alternates, :class_name => 'Player', :foreign_key => 'main_character_id'
  belongs_to :main_character, :class_name => 'Player', :foreign_key => 'main_character_id'
  belongs_to :archetype
  belongs_to :rank

  #TODO Decide whether to have a player linking to character(s) of different ranks

  has_and_belongs_to_many :raids
  has_many :drops

  validates_presence_of :name

  def loot_rate(loot_type)
    num_drops = 0
    drops.each do |drop|
      if drop.item.loot_type && (drop.item.loot_type.name.eql? loot_type)
        num_drops += 1
      end
    end
    raids.count / (num_drops + 1)
  end

  def self.find_by_archetype(archetype)
    all_players = Player.all(:conditions => ['archetype_id = ?', archetype.id], :order => :name).flatten

    Archetype.find_all_children(archetype).each do |child_archetype|
      all_players << Player.all(:conditions => ['archetype_id = ?', child_archetype.id], :order => :name).flatten
    end
    all_players.collect
    return all_players.flatten.uniq
  end

  def self.find_main_characters
    Player.find_by_main_character_id(nil, :order => 'name')
  end
end