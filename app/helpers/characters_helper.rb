module CharactersHelper
  def main_character_name(character)
    if character.player
      main_character = character.player.characters.where(:char_type => 'm').first
      main_character ? main_character.name : "Unknown"
    else
      "Unknown"
    end
  end
end