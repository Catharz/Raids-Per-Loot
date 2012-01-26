require File.dirname(__FILE__) + '/../../app/validators/archetype_validator'

class Archetype < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_and_belongs_to_many :items
  has_many :players
  validates_with ArchetypeValidator

  has_many :sub_classes, :class_name => 'Archetype', :foreign_key => 'parent_class_id'
  belongs_to :parent_class, :class_name => 'Archetype', :foreign_key => 'parent_class_id'


  def main_class
    if parent_class.nil?
      self
    else
      parent_class.main_class
    end
  end

  def self.find_parent(archetype)
    Archetype.find_by_id(archetype.parent_class_id)
  end

  # This only handles a depth of 4 classes, which is more than enough for EQ2!
  def self.find_all_children(first_class)
    archetypes = [first_class]
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

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "archetype"
    xml_attributes = self.attributes
    xml_attributes["players"] = self.players
    xml_attributes["items"] = self.items
    xml_attributes.to_xml(to_xml_opts)
  end
end
