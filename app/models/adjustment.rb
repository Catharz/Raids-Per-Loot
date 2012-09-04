class Adjustment < ActiveRecord::Base
  belongs_to :adjustable, :polymorphic => true
  has_many :archetypes_items
  has_many :items, :through => :archetypes_items

  def self.for_period(range = {start:  nil, end: nil})
    adjustments = scoped
    adjustments = where('adjustment_date >= ?', range[:start]) if range[:start]
    adjustments = where('adjustment_date <= ?', range[:end]) if range[:end]
    adjustments
  end

  def self.for_character(character_id)
    character_id ? by_adjustable_type('Character').where(:adjustable_id => character_id) : scoped
  end

  def self.for_player(player_id)
    player_id ? by_adjustable_type('Player').where(:adjustable_id => player_id) : scoped
  end

  def self.by_adjustable_type(adjustable_type)
    adjustable_type ? where(:adjustable_type => adjustable_type) : scoped
  end

  def self.by_adjustment_type(adjustment_type)
    adjustment_type ? where(:adjustment_type => adjustment_type) : scoped
  end

  def adjusted_name
    adjustable ? adjustable.name : "Unknown"
  end

  def adjustment_types
    %w{Raids Instances} + LootType.option_names.flatten
  end

  def type_label
    adjustable_type ? "#{adjustable_type}:" : "Player/Character:"
  end

  def adjustable_entities
    adjustable_type ? eval(adjustable_type).order(:name) : []
  end
end
