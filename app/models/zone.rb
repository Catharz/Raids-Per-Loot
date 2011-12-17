class Zone < ActiveRecord::Base
  has_many :raids
  has_many :drops
  has_and_belongs_to_many :mobs, :join_table => "zones_mobs"
  validates_presence_of :name
  validates_uniqueness_of :name
end
