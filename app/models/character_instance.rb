class CharacterInstance < ActiveRecord::Base
  belongs_to :character, :inverse_of => :character_instances
  belongs_to :instance, :inverse_of => :character_instances

  validates_uniqueness_of :character_id, :scope => :instance_id
end
