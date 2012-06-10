class CharacterDetailsJob < Struct.new(:character)
  def perform
    character.fetch_soe_character_details unless character.nil?
  end
end