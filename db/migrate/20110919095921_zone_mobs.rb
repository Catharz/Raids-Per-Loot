class ZoneMobs < ActiveRecord::Migration
  def self.up
    create_table :zones_mobs, :id => false do |t|
      t.integer :zone_id
      t.integer :mob_id
    end
  end

  def self.down
    drop_table :zones_mobs
  end
end
