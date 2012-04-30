class AddLootMethodToDrops < ActiveRecord::Migration
  def change
    add_column :drops, :loot_method, :string, :length => 1, :default => 'n'
  end
end
