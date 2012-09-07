class AddChildrenCountToPage < ActiveRecord::Migration
  def change
    add_column :pages, :children_count, :integer, default: 0, null: false
  end
end
