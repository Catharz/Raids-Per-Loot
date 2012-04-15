class AddCharTypeToCharacters < ActiveRecord::Migration
  # Found I really DO need the character type on the character row
  def up
    add_column :characters, :char_type, :string, :length => 1
    Character.reset_column_information
    CharacterType.order("effective_date").all.each do |character_type|
      character_type.character.update_attribute(:char_type, character_type.char_type)
    end
  end

  def down
    remove_column :characters, :char_type
  end
end
