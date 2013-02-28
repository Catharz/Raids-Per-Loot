class CharacterDetailsJob < Struct.new(:character)
  def perform
    SonyDataService.new.fetch_soe_character_details(character) unless character.nil?
  end
end