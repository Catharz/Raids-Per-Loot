# @author Craig Read
#
# Difficulty represents the difficulty of a Zone
# or a mob within a Zone.
class Difficulty < ActiveRecord::Base
  has_many :mobs, :inverse_of => :difficulty
  has_many :zones, :inverse_of => :difficulty

  validates_presence_of :name, :rating
end
