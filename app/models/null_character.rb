class NullCharacter
  attr_reader :id, :name, :general_alternates

  def initialize(name = 'Unknown')
    @id = nil
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
    '/'
  end

  def html_id
    nil
  end
end