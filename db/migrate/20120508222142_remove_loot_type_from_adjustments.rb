class RemoveLootTypeFromAdjustments < ActiveRecord::Migration
  def up
    remove_column :adjustments, :loot_type_id
  end

  def down
    add_column :adjustments, :loot_type_id, :integer
  end
end
