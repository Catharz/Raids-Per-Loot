# @author Craig Read
#
# PlayerCharacter is a composite representing
# the Player and one of their Characters.
# This is used to simplify editing loot statistics
# for a particular player and character.
class PlayerCharacter
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_reader :id
  attr_reader :player
  attr_reader :character

  attribute :id, Integer
  attribute :player, Player
  attribute :character, Character

  def initialize(character_id)
    @id = character_id.to_i
    @character = Character.find(id)
    @player = Player.find(@character.player_id)
  end

  def reload
    @character.reload
    @player.reload
  end

  def persisted?
    false
  end

  def save
    true
  end

  def eql?(other)
    @id.eql? other.id and @character.eql? other.character and @player.eql? other.player
  end

  def ==(other)
    @id == other.id and @character == other.character and @player == other.player
  end
end
