class CreateDrops < ActiveRecord::Migration
  def self.up
    create_table :drops do |t|
      t.string :zone_name
      t.string :mob_name
      t.string :player_name
      t.string :item_name
      t.string :eq2_item_id
      t.datetime :drop_time

      t.timestamps
    end
  end

  def self.down
    drop_table :drops
  end
end
