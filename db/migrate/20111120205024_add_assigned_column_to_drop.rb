class AddAssignedColumnToDrop < ActiveRecord::Migration
  def self.up
    add_column :drops, :assigned, :boolean
  end

  def self.down
    remove_column :drops, :assigned
  end
end
