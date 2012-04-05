class CharacterType < ActiveRecord::Base
  belongs_to :character
  validates_format_of :char_type, :with => /g|m|r/ # General Alt, Main, Raid Alt
  validates_presence_of :character_id, :char_type, :effective_date

  def self.by_character(character_id)
    character_id ? where("character_id = ?", character_id) : scoped
  end
end
