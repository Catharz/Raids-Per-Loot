class ItemsSlots < ActiveRecord::Migration
  def self.up
    create_table :items_slots, :id => false do |t|
      t.integer :item_id
      t.integer :slot_id
    end
  end

  def self.down
    drop_table :items_slots
  end
end
