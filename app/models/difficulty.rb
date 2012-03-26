class Difficulty < ActiveRecord::Base
  has_many :mobs
  has_many :zones
end
