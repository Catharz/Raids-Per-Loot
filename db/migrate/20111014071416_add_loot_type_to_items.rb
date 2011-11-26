class AddLootTypeToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :loot_type_id, :integer
  end

  def self.down
    remove_column :items, :loot_type_id
  end
end
