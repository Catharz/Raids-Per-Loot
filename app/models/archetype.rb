class Archetype < ActiveRecord::Base
  acts_as_tree :order => "name"

  has_many :characters, :inverse_of => :archetype

  has_many :archetypes_items, :inverse_of => :archetype
  has_many :items, :through => :archetypes_items

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_with ArchetypesValidator

  def self.by_item(item_id)
    item_id ? items.where('id = ?', item_id) : scoped
  end

  def self.root_names
    root_name_list = []
    self.roots.each { |a| root_name_list << a.name }
    root_name_list << "Unknown"
    root_name_list
  end

  def self.root_list
    roots = {}
    Archetype.order(:name).each.map { |archetype| roots.merge! archetype.name => archetype.root.name }
    roots
  end

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

  def self.base_archetypes
    child_archetypes.not_parent_archetypes.order(:name)
  end

  def self.not_parent_archetypes
    where('id not in (select parent_id from archetypes where parent_id is not null)')
  end

  def self.child_archetypes
    where('parent_id is not null')
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
