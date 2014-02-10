class DropAdjustments < ActiveRecord::Migration
  def up
    drop_table :adjustments
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Cannot reverse dropping the adjustments table"
  end
end
