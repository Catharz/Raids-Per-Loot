class AddZoneToRaids < ActiveRecord::Migration
  def self.up
    add_column :raids, :zone_id, :integer
  end

  def self.down
    remove_column :raids, :zone_id
  end
end
