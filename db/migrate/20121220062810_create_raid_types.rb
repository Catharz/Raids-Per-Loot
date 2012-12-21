class CreateRaidTypes < ActiveRecord::Migration
  def create_raid_types
    raid_types = [{name: "Progression", raid_counted: true, raid_points: 1, loot_counted: true, loot_cost: 1.0},
                  {name: "Normal", raid_counted: true, raid_points: 1, loot_counted: true, loot_cost: 1.0},
                  {name: "Pickup", raid_counted: false, raid_points: 0, loot_counted: false, loot_cost: 0.0},
                  {name: "Alternate", raid_counted: true, raid_points: 1, loot_counted: true, loot_cost: 1.0},
                  {name: "Trash Clearing", raid_counted: false, raid_points: 0, loot_counted: false, loot_cost: 0.0}]
    RaidType.create!(raid_types)
  end

  def up
    create_table :raid_types do |t|
      t.string :name, :unique => true
      t.boolean :raid_counted, :default => true
      t.float :raid_points, :default => 1.0
      t.boolean :loot_counted, :default => true
      t.float :loot_cost, :default => 1.0

      t.timestamps
    end
    create_raid_types
  end

  def down
    drop_table :raid_types
  end
end
