class Item < ActiveRecord::Base
  has_many :drops
  has_and_belongs_to_many :slots
  has_and_belongs_to_many :archetypes
  belongs_to :loot_type
  validates_presence_of :name, :eq2_item_id
  validates_uniqueness_of :name, :eq2_item_id

  def class_names
    result = nil
    archetypes.each do |archetype|
      if result
        result << ', ' + archetype.name
      else
        result = archetype.name
      end
    end
    result
  end

  def slot_names
    result = nil
    slots.each do |slot|
      if result
        result << ', ' + slot.name
      else
        result = slot.name
      end
    end
    result
  end
end
