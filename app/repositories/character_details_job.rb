class CharacterDetailsJob < Struct.new(:character_name)
  def perform
    if character_name
      character = Character.find_by_name(character_name)
      character.fetch_soe_character_details unless character.nil?
    end
  end
end