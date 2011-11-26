class PlayerAlternates < ActiveRecord::Migration
  def self.up
    add_column :players, :main_character, :integer
  end

  def self.down
    remove_column :players, :main_character, :integer
  end
end
