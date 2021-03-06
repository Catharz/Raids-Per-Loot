# @author Craig Read
#
# Slot represents the slot an item can
# be equipped in such as Primary (right-hand)
# Secondary (left-hand), Ring, Wrist, Waist, etc
class Slot < ActiveRecord::Base
  has_many :items_slots
  has_many :items, :through => :items_slots

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "slot"
    self.attributes.to_xml(to_xml_opts)
  end
end