class Adjustment < ActiveRecord::Base
  belongs_to :adjustable, :polymorphic => true
  has_many :archetypes_items
  has_many :items, :through => :archetypes_items

  scope :for_period, ->(range = {start: nil, end: nil}) {
    adjustments = scoped
    adjustments = where('adjustment_date >= ?', range[:start]) if range[:start]
    adjustments = where('adjustment_date <= ?', range[:end]) if range[:end]
    adjustments
  }
  scope :for_character, ->(character_id = nil) {
    character_id ? by_adjustable_type('Character').where(:adjustable_id => character_id) : scoped
  }
  scope :for_player, ->(player_id = nil) {
    player_id ? by_adjustable_type('Player').where(:adjustable_id => player_id) : scoped
  }
  scope :by_adjustable_type, ->(adjustable_type = nil) {
    adjustable_type ? where(:adjustable_type => adjustable_type) : scoped
  }
  scope :by_adjustment_type, ->(adjustment_type = nil) {
    adjustment_type ? where(:adjustment_type => adjustment_type) : scoped
  }

  def adjusted_name
    adjustable ? adjustable.name : 'Unknown'
  end

  def adjustment_types
    %w{Raids Instances} + LootType.option_names.flatten
  end

  def type_label
    adjustable_type ? "#{adjustable_type}:" : 'Player/Character:'
  end

  def adjustable_entities
    adjustable_type ? eval(adjustable_type).order(:name) : []
  end
end