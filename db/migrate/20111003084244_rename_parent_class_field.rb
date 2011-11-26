class RenameParentClassField < ActiveRecord::Migration
  def self.up
    rename_column :archetypes, :parent_class, :parent_class_id
  end

  def self.down
    rename_column :archetypes, :parent_class_id, :parent_class
  end
end
