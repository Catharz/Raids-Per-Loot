# @author Craig Read
#
# Rank represents the rank of the player
# or person playing a character
class Rank < ActiveRecord::Base
  has_many :players, :inverse_of => :rank

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "rank"
    self.attributes.to_xml(to_xml_opts)
  end
end
