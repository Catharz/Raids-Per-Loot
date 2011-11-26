class FixPlayerMainCharacterId < ActiveRecord::Migration
  def self.up
    rename_column :players, :main_character, :main_character_id
  end

  def self.down
    rename_column :players, :main_character_id, :main_character
  end
end
