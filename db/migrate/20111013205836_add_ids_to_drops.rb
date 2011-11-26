class AddIdsToDrops < ActiveRecord::Migration
  def self.up
    add_column :drops, :zone_id, :integer
    add_column :drops, :raid_id, :integer
    add_column :drops, :mob_id, :integer
    add_column :drops, :player_id, :integer
    add_column :drops, :item_id, :integer
  end

  def self.down
    remove_column :drops, :zone_id
    remove_column :drops, :raid_id
    remove_column :drops, :mob_id
    remove_column :drops, :player_id
    remove_column :drops, :item_id
  end
end
