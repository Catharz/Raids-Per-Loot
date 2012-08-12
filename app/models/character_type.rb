class CharacterType < ActiveRecord::Base
  belongs_to :character, :inverse_of => :character_types

  validates_presence_of :character_id, :char_type, :effective_date
  validates_format_of :char_type, :with => /g|m|r/ # General Alt, Main, Raid Alt

  scope :by_character_and_date,
        lambda { |character_id, date| by_character(character_id).as_at(date) }

  def self.by_character(character_id = nil)
    character_id ? where(['character_id = ?', character_id]) : scoped
  end

  def self.as_at(date = nil)
    date ? where('effective_date <= ?', date).order('effective_date desc').limit(1) : []
  end
end
