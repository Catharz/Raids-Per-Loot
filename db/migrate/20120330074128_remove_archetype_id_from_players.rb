class RemoveArchetypeIdFromPlayers < ActiveRecord::Migration
  class Player < ActiveRecord::Base
    belongs_to :archetype
  end

  def up
    remove_column :players, :archetype_id
  end

  def down
    add_column :players, :archetype_id, :integer
    Player.reset_column_information
    Character.where("char_type = 'm'").all.each do |character|
      player = Player.find_by_name(character.name)
      player.update_attributes(:archetype_id => character.archetype_id) if player
    end
  end
end
