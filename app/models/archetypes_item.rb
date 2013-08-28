# @author Craig Read
#
# ArchetypesItem resolves the many-to-many
# relationships between archetypes and items
class ArchetypesItem < ActiveRecord::Base
  belongs_to :archetype, :inverse_of => :archetypes_items
  belongs_to :item, :inverse_of => :archetypes_items, :touch => true

  delegate :name, to: :archetype, prefix: :archetype, allow_nil: true
  delegate :name, to: :item, prefix: :item, allow_nil: true
end