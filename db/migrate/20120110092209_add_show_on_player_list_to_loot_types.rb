class AddShowOnPlayerListToLootTypes < ActiveRecord::Migration
  def self.up
    add_column :loot_types, :show_on_player_list, :boolean, :default => true
  end

  def self.down
    remove_column :loot_types, :show_on_player_list
  end
end
