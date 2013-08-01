class CharacterStatisticsRating
  include Comparable

  def self.from_rating(rating_string)
    case rating_string
      when 'optimal'
        new('A')
      when 'minimum'
        new('B')
      else
        new('C')
    end
  end

  def initialize(rating)
    @rating = rating
  end

  def better_than?(other)
    self > other
  end

  def <=>(other)
    other.to_s <=> to_s
  end

  def hash
    @rating.hash
  end

  def eql?(other)
    to_s == other.to_s
  end

  def to_s
    case rating
      when 'A'
        'Optimal'
      when 'B'
        'Minimum'
      else
        'Unsatisfactory'
    end
  end
end