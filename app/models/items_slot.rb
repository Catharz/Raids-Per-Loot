class ItemsSlot < ActiveRecord::Base
  belongs_to :item, :inverse_of => :items_slots, :touch => true
  belongs_to :slot, :inverse_of => :items_slots
end