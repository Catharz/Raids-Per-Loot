# @author Craig Read
#
# NullCharacter is used to represent a relation
# not having a character assigned
class NullCharacter
  attr_reader :id, :name, :general_alternates

  def initialize(name = 'Unknown')
    @id = -1
    @name = name
    @general_alternates = []
  end

  def main_character(name = nil)
    NullCharacter.new(name)
  end

  def raid_alternate(name = nil)
    NullCharacter.new(name)
  end

  def path(options = {})
    ''
  end

  def html_id
    ''
  end
end