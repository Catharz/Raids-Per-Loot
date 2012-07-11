class LootType < ActiveRecord::Base
  has_many :items, :inverse_of => :loot_type
  has_many :drops, :inverse_of => :loot_type

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :default_loot_method, :with => /n|r|b|t/ # Need, Random, Bid, Trash

  def self.option_names
    names = []
    LootType.where(:default_loot_method => 'n').order(:name).each do |loot_type|
      names << loot_type.name
    end
    names
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
