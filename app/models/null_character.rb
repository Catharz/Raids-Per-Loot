class NullCharacter
  attr_reader :name, :general_alternates

  def initialize(name = 'Unknown')
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
    'Unknown'
  end

  def html_id
    nil
  end
end