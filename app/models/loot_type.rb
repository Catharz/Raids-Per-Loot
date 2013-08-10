class LootType < ActiveRecord::Base
  include LootMethodHelper
  has_many :items, :inverse_of => :loot_type
  has_many :drops, :inverse_of => :loot_type

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :default_loot_method, :with => /n|r|b|g|t/ # Need, Random, Bid, Guild Bank, Trash

  def self.option_names
    where(:default_loot_method => 'n').order(:name).each.collect { |loot_type| loot_type.name }
  end

  def default_loot_method_name
    loot_method_description default_loot_method
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "loot_type"
    self.attributes.to_xml(to_xml_opts)
  end
end
