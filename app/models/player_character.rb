class PlayerCharacter
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :id
  attr_reader :player
  attr_reader :character

  attribute :player
  attribute :character
  attribute :main_character, Character
  attribute :raid_alternate, Character

  attribute :id, Integer
  attribute :active
  attribute :raids_count, Integer
  attribute :armour_count, Integer
  attribute :jewellery_count, Integer
  attribute :weapons_count, Integer
  attribute :adornments_count, Integer
  attribute :dislodgers_count, Integer
  attribute :mounts_count, Integer
  attribute :switches_count, Integer
  attribute :confirmed_rating, String
  attribute :confirmed_date, Date

  validates :raids_count, presence: true
  validates :armour_count, presence: true
  validates :jewellery_count, presence: true
  validates :weapons_count, presence: true
  validates :adornments_count, presence: true
  validates :dislodgers_count, presence: true
  validates :mounts_count, presence: true
  validates :switches_count, presence: true
  validate do |player_character|
    player_character.must_have_rating_with_date
  end

  def initialize(character_id)
    @id = character_id.to_i
    @character = Character.find(id)
    @player = Player.find(@character.player_id)
    read_attributes
  end

  def reload
    @character.reload
    @player.reload
    read_attributes
  end

  def persisted?
    false
  end

  def update_attributes(attributes)
    if attributes.nil?
      errors.add(:base, 'Rejecting nil attributes for player character!')
      return false
    end
    @active = attributes[:active]
    @raids_count = attributes[:raids_count].to_i
    @switches_count = attributes[:switches_count].to_i
    @armour_count = attributes[:armour_count].to_i
    @jewellery_count = attributes[:jewellery_count].to_i
    @weapons_count = attributes[:weapons_count].to_i
    @adornments_count = attributes[:adornments_count].to_i
    @dislodgers_count = attributes[:dislodgers_count].to_i
    @mounts_count = attributes[:mounts_count].to_i
    @confirmed_rating = attributes[:confirmed_rating]
    @confirmed_date = attributes[:confirmed_date]
    save
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def must_have_rating_with_date
    return if confirmed_date.nil? and confirmed_rating.nil?
    return if !confirmed_date.nil? and !confirmed_rating.nil?
    errors.add(:base, 'Must have a rating and a date')
  end

  def eql?(other)
    @id.eql? other.id and @character.eql? other.character and @player.eql? other.player
  end

  def ==(other)
    @id == other.id and @character == other.character and @player == other.player
  end

  private

  def read_attributes
    @main_character = @character.current_main
    @raid_alternate = @character.current_raid_alternate

    @active = @player.active
    @raids_count = @player.raids_count.to_i
    @switches_count = @player.switches_count.to_i
    @armour_count = @character.armour_count.to_i
    @jewellery_count = @character.jewellery_count.to_i
    @weapons_count = @character.weapons_count.to_i
    @adornments_count = @character.adornments_count.to_i
    @dislodgers_count = @character.dislodgers_count.to_i
    @mounts_count = @character.mounts_count.to_i

    @confirmed_rating = @character.confirmed_rating
    @confirmed_date = @character.confirmed_date
  end

  def persist!
    @player.update_attributes(active: active, raids_count: raids_count, switches_count: switches_count)
    @character.update_attributes(armour_count: armour_count,
                                 jewellery_count: jewellery_count,
                                 weapons_count: weapons_count,
                                 adornments_count: adornments_count,
                                 dislodgers_count: dislodgers_count,
                                 mounts_count: mounts_count,
                                 confirmed_rating: confirmed_rating,
                                 confirmed_date: confirmed_date)
  end
end