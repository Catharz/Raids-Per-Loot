class RaidType < ActiveRecord::Base
  has_many :raids, inverse_of: :raid_type
  has_many :instances, through: :raids

  validates_presence_of :name
end
