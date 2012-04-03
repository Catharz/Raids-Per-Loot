class CharacterInstance < ActiveRecord::Base
  belongs_to :character
  belongs_to :instance

  validates_uniqueness_of :character_id, :scope => :instance_id
end
