class Archetype < ActiveRecord::Base
  acts_as_tree :order => 'name'

  has_many :characters, :inverse_of => :archetype

  has_many :archetypes_items, :inverse_of => :archetype
  has_many :items, :through => :archetypes_items

  delegate :name, to: :root, prefix: :root, allow_nil: true
  delegate :name, to: :parent, prefix: :parent, allow_nil: true
  delegate :name, to: :root, prefix: :root

  after_commit :invalidate_caches

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

  def self.root_list
    @archetype_roots = Rails.cache.fetch('archetype_roots') do
      roots = {}
      Archetype.order(:name).each.map { |archetype| roots.merge! archetype.name => archetype.root.name }
      roots
    end
  end

  def family
    root.descendants( [root] )
  end

  def descendants(list = [])
    (list + children.map { |c| [c] + c.descendants(list) }).uniq.flatten
  end

  def potential_parents
    @potential_parents = Rails.cache.fetch('potential_parents') do
      Archetype.order(:name) - self.descendants([self])
    end
  end

  def invalidate_caches
    Rails.cache.delete('potential_parents')
    Rails.cache.delete('archetype_roots')
  end
end
