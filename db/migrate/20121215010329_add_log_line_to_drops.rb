class AddLogLineToDrops < ActiveRecord::Migration
  def change
    add_column :drops, :log_line, :string
    add_index :drops, :log_line
  end
end
