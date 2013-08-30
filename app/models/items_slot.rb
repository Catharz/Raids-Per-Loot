# @author Craig Read
#
# ItemsSlot resolves the many-to-many relationship between
# Items (Sword, Shield, Ring, etc) and Slots (Primary, Secondary, Finger, etc)
class ItemsSlot < ActiveRecord::Base
  belongs_to :item, :inverse_of => :items_slots, :touch => true
  belongs_to :slot, :inverse_of => :items_slots

  delegate :name, to: :item, prefix: :item, allow_nil: true
  delegate :name, to: :slot, prefix: :slot, allow_nil: true
end