# @author Craig Read
#
# CharacterInstance resolves the many-to-many
# relationship between Character and Instance,
# while also adding the ability to define if
class CharacterInstance < ActiveRecord::Base
  belongs_to :character, :inverse_of => :character_instances, :touch => true
  belongs_to :instance, :inverse_of => :character_instances, :touch => true

  validates_uniqueness_of :character_id, :scope => :instance_id

  scope :by_character, ->(character_id) {
    character_id ? where(:character_id => character_id) : scoped
  }
  scope :by_instance, ->(instance_id) {
    instance_id ? where(:instance_id => instance_id) : scoped
  }
end
