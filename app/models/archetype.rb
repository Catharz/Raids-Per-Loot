class Archetype < ActiveRecord::Base
  acts_as_tree :order => "name"

  validates_presence_of :name
  validates_uniqueness_of :name
  has_and_belongs_to_many :items
  has_many :players
  validates_with ArchetypesValidator

  # This only handles a depth of 4 classes, which is more than enough for EQ2!
  def self.descendants(root_archetype)
    archetypes = []
    root_archetype.children.each do |second_class|
      archetypes << second_class
      second_class.children.each do |third_class|
        archetypes << third_class
        third_class.children.each do |fourth_class|
          archetypes << fourth_class
        end
      end
    end
    return archetypes.flatten
  end

  # This only handles a depth of 4 classes, which is more than enough for EQ2!
  def self.family(root_archetype)
    archetypes = []
    archetypes << root_archetype.root unless root_archetype.root.nil?
    archetypes << root_archetype if archetypes.empty?
    archetypes << descendants(root_archetype)
    return archetypes.flatten
  end

  def self.find_base_classes
    base_classes = Array.new
    Archetype.all(:order => :name).each do |archetype|
      if Archetype.find_all_by_parent_id(archetype.id).empty?
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
