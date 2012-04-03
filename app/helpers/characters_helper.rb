module CharactersHelper
  def main_character_name(character)
    if character.player
      character.player.main_character ? character.player.main_character.name : "Unknown"
    else
      "Unknown"
    end
  end
end