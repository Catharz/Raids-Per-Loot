class CharacterInstance < ActiveRecord::Base
  belongs_to :character, :inverse_of => :character_instances, :touch => true
  belongs_to :instance, :inverse_of => :character_instances, :touch => true

  validates_uniqueness_of :character_id, :scope => :instance_id
end
