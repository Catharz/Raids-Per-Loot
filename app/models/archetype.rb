class Archetype < ActiveRecord::Base
  acts_as_tree :order => "name"

  has_many :characters, :inverse_of => :archetype

  has_many :archetypes_items, :inverse_of => :archetype
  has_many :items, :through => :archetypes_items

  delegate :name, to: :root, prefix: :root, allow_nil: true
  delegate :name, to: :parent, prefix: :parent, allow_nil: true

  validates_presence_of :name
  validates_uniqueness_of :name

  scope :by_item, ->(item_id) {
    item_id ? items.where('id = ?', item_id) : scoped
  }
  scope :child_archetypes, -> {
    where('parent_id is not null')
  }
  scope :not_parent_archetypes, -> {
    where('id not in (select parent_id from archetypes where parent_id is not null)')
  }
  scope :base_archetypes, -> {
    child_archetypes.not_parent_archetypes.order(:name)
  }

  def self.root_names
    root_name_list = []
    self.roots.each { |a| root_name_list << a.name }
    root_name_list << 'Unknown'
    root_name_list
  end

  def self.root_list
    roots = {}
    Archetype.order(:name).each.map { |archetype| roots.merge! archetype.name => archetype.root.name }
    roots
  end

  def family
    root.descendants( [root] )
  end

  def descendants(list = [])
    (list + children.map { |c| [c] + c.descendants(list) }).uniq.flatten
  end

  def potential_parents
    Archetype.order(:name) - self.descendants([self])
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
