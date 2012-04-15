class ArchetypesItem < ActiveRecord::Base
  belongs_to :archetype, :inverse_of => :archetypes_items
  belongs_to :item, :inverse_of => :archetypes_items
end