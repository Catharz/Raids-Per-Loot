class RenameParentClassIdColumn < ActiveRecord::Migration
  def self.up
    rename_column :archetypes, :parent_class_id, :parent_id
  end

  def self.down
    rename_column :archetypes, :parent_id, :parent_class_id
  end
end
