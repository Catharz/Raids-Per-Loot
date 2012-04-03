class AddCharactersToDrops < ActiveRecord::Migration
  def up
    Drop.reset_column_information
    Drop.all.each do |drop|
      drop.update_attribute(:player_id, Character.find_by_name(drop.player_name).id)
    end
    rename_column :drops, :player_name, :character_name
    rename_column :drops, :player_id, :character_id
    rename_column :drops, :assigned_to_player, :assigned_to_character
  end

  def down
    Drop.reset_column_information
    Drop.all.each do |drop|
      drop.update_attribute(:character_id, Player.find_by_name(drop.character_name).id)
    end
    rename_column :drops, :character_name, :player_name
    rename_column :drops, :character_id, :player_id
    rename_column :drops, :assigned_to_character, :assigned_to_player
  end
end
