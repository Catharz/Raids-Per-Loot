class RemovePlayersMainCharacterId < ActiveRecord::Migration
  def up
    remove_column :players, :main_character_id
  end

  def down
    add_column :players, :main_character_id, :integer
  end
end
