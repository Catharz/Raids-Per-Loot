class AddIdToItemsSlots < ActiveRecord::Migration
  def change
    change_table :items_slots do |t|
      t.column :id, :primary_key, :before => :item_id
      t.timestamps
    end
  end
end
