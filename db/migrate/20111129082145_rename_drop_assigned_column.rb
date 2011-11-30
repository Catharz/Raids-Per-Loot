class RenameDropAssignedColumn < ActiveRecord::Migration
  def self.up
    rename_column :drops, :assigned, :assigned_to_player
  end

  def self.down
    rename_column :drops, :assigned_to_player, :assigned
  end
end
