class DropUnusedTables < ActiveRecord::Migration
  def up
    drop_table :instances_players
    drop_table :zones_mobs
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Cannot reverse dropping the instances_players or zones_mobs tables"
  end
end
