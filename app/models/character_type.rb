class CharacterType < ActiveRecord::Base
  include CharactersHelper
  belongs_to :character, :inverse_of => :character_types

  validates_presence_of :character_id, :char_type, :effective_date
  validates_format_of :char_type, :with => /g|m|r/ # General Alt, Raid Main, Raid Alt

  delegate :name, to: :character, prefix: :character, allow_nil: true
  delegate :player_name, to: :character
  delegate :first_raid, to: :character, allow_nil: true
  delegate :last_raid, to: :character, allow_nil: true

  scope :none, where(:id => nil).where('id IS NOT ?', nil)
  scope :by_character, ->(character_id = nil) {
    character_id ? where(character_id: character_id) : scoped
  }
  scope :as_at, ->(date = nil) {
    date ? where('effective_date <= ?', date).order('effective_date desc').limit(1) : none
  }
  scope :by_character_and_date, ->(character_id, date) {
      by_character(character_id).as_at(date)
  }

  def character_type_name
    char_type_name(char_type)
  end

  def character_first_raid_date
    character.first_raid ? character.first_raid.raid_date : 'Never'
  end

  def character_last_raid_date
    character.last_raid ? character.last_raid.raid_date : 'Never'
  end
end
