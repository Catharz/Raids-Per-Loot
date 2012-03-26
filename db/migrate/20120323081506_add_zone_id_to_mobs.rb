class AddZoneIdToMobs < ActiveRecord::Migration
  def self.up
    add_column :mobs, :zone_id, :integer
    Mob.reset_column_information
    Zone.all.each do |zone|
      zone.mobs.each do |mob|
        mob.zone_id = zone.id
        mob.save!
      end
    end
    drop_table :zones_mobs
  end

  def self.down
    create_table :zones_mobs, :id => false do |t|
      t.integer :zone_id
      t.integer :mob_id
    end
    Zone.all.each do |zone|
      zone.mobs.each do |mob|
        execute("insert into zones_mobs (zone_id, mob_id) values (#{zone.id}, #{mob.id}")
      end
    end
  end
end
