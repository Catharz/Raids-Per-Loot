class PlayerCharacter
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :player
  attr_reader :character

  attribute :player
  attribute :character
  attribute :main_character, Character
  attribute :raid_alternate, Character

  attribute :active
  attribute :raids_count, Integer
  attribute :armour_count, Integer
  attribute :jewellery_count, Integer
  attribute :weapons_count, Integer
  attribute :adornments_count, Integer
  attribute :dislodgers_count, Integer
  attribute :mounts_count, Integer

  validates :raids_count, presence: true
  validates :armour_count, presence: true
  validates :jewellery_count, presence: true
  validates :weapons_count, presence: true
  validates :adornments_count, presence: true
  validates :dislodgers_count, presence: true
  validates :mounts_count, presence: true

  def initialize(character_id)
    @character = Character.find(character_id)
    @player = Player.find(@character.player_id)
    @main_character = @character.current_main
    @raid_alternate = @character.current_raid_alternate

    @active = @player.active
    @raids_count = @player.raids_count
    @armour_count = @character.armour_count
    @jewellery_count = @character.jewellery_count
    @weapons_count = @character.weapons_count
    @adornments_count = @character.adornments_count
    @dislodgers_count = @character.dislodgers_count
    @mounts_count = @character.mounts_count
  end

  def persisted?
    false
  end

  def update_attributes(attributes)
    @active = attributes[:active]
    @raids_count = attributes[:raids_count]
    @armour_count = attributes[:armour_count]
    @jewellery_count = attributes[:jewellery_count]
    @weapons_count = attributes[:weapons_count]
    @adornments_count = attributes[:adornments_count]
    @dislodgers_count = attributes[:dislodgers_count]
    @mounts_count = attributes[:mounts_count]
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

  private

  def persist!
    # We use update attribute on the player
    #@player.update_attribute(:active, active)
    #@player.update_attribute(:raids_count, raids_count)
    @player.update_attributes(active: active, raids_count: raids_count)
    @character.update_attributes(armour_count: armour_count,
                                 jewellery_count: jewellery_count,
                                 weapons_count: weapons_count,
                                 adornments_count: adornments_count,
                                 dislodgers_count: dislodgers_count,
                                 mounts_count: mounts_count)
  end
end