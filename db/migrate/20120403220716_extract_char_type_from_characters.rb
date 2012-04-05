class ExtractCharTypeFromCharacters < ActiveRecord::Migration
  def up
    Character.all.each do |char|
      effective_date = char.first_raid ? char.first_raid.raid_date : char.created_at
      CharacterType.create(
          :character_id => char.id,
          :effective_date => effective_date,
          :char_type => char.char_type)
    end
    remove_column :characters, :char_type
  end

  def down
    add_column :characters, :char_type, :string, :length => 1
    Character.reset_column_information
    CharacterType.order("effective_date").all.each do |character_type|
      character_type.character.update_attribute(:char_type, character_type.char_type)
    end
    CharacterType.delete_all
  end
end
