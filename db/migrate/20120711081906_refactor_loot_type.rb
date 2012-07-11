class RefactorLootType < ActiveRecord::Migration
  def up
    remove_column :loot_types, :show_on_player_list
    add_column :loot_types, :default_loot_method, :string, :limit => 1, :default => 'n'
  end

  def down
    add_column :loot_type, :show_on_player_list, :boolean, :default => true
    remove_column :loot_types, :show_on_player_list
  end
end
