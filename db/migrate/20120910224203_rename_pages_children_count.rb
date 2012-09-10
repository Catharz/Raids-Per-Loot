class RenamePagesChildrenCount < ActiveRecord::Migration
  def up
    rename_column :pages, :children_count, :pages_count
  end

  def down
    rename_column :pages, :pages_count, :children_count
  end
end
