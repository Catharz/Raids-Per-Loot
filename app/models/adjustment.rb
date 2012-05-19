class Adjustment < ActiveRecord::Base
  belongs_to :adjustable, :polymorphic => true
  has_many :archetypes_items
  has_many :items, :through => :archetypes_items

  def self.for_character(character_id)
    character_id ? adjustable('Character').where(:adjustable_id => character_id) : scoped
  end

  def self.for_player(player_id)
    player_id ? adjustable('Player').where(:adjustable_id => player_id) : scoped
  end

  def self.adjustable(adjustable_type)
    adjustable_type ? where(:adjustable_type => adjustable_type) : scoped
  end

  def self.of_type(adjustment_type)
    adjustment_type ? where(:adjustment_type => adjustment_type) : scoped
  end

  def name
    adjustable ? adjustable.name : "Unknown"
  end

end
