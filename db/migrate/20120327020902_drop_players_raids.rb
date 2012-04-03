class DropPlayersRaids < ActiveRecord::Migration
  def up
    drop_table :players_raids
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Cannot reverse dropping the players_raids table"
  end
end
