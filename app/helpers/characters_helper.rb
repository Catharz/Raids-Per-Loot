module CharactersHelper
  def main_character_name(character)
    if character.player
      main_character = nil
      family = character.player.characters
      family.each do |member|
        if member.current_char_type.char_type.eql? 'm'
          main_character ||= member
        end
      end
      main_character ? main_character.name : "Unknown"
    else
      "Unknown"
    end
  end
end