class Difficulty < ActiveRecord::Base
  has_many :mobs, :inverse_of => :difficulty
  has_many :zones, :inverse_of => :difficulty
end
