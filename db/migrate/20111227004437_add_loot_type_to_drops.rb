class AddLootTypeToDrops < ActiveRecord::Migration
  def self.up
    add_column :drops, :loot_type_name, :string
    add_column :drops, :loot_type_id, :integer
  end

  def self.down
    remove_column :drops, :loot_type_id
    remove_column :drops, :loot_type_name
  end
end
