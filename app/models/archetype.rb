class Archetype < ActiveRecord::Base
  require 'archetype_validator'
  validates_presence_of :name
  validates_uniqueness_of :name
  has_and_belongs_to_many :items
  validates_with ArchetypeValidator

  has_many :sub_classes, :class_name => 'Archetype', :foreign_key => 'parent_class_id'
  belongs_to :parent_class, :class_name => 'Archetype', :foreign_key => 'parent_class_id'

  def self.find_parent(archetype)
    Archetype.find_by_id(archetype.parent_class_id)
  end

  # This only handles a depth of 4 classes, which is more than enough for EQ2!
  def self.find_all_children(first_class)
    archetypes = Array(first_class)
    first_class.sub_classes.each do |second_class|
      archetypes << second_class
      second_class.sub_classes.each do |third_class|
        archetypes << third_class
        third_class.sub_classes.each do |fourth_class|
          archetypes << fourth_class
        end
      end
    end
    return archetypes.flatten
  end

  def self.main_classes
    Archetype.find_all_by_parent_class_id(nil, :order => :name)
  end

  def self.find_base_classes
    base_classes = Array.new
    Archetype.all(:order => :name).each do |archetype|
      if Archetype.find_all_by_parent_class_id(archetype.id).empty?
        base_classes << archetype
      end
    end
    return base_classes.flatten
  end
end
