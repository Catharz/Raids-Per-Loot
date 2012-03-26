class Zone < ActiveRecord::Base
  belongs_to :difficulty
  has_many :instances
  has_many :drops
  has_many :mobs

  has_one :last_instance,
      :class_name => 'Instance',
      :order => 'start_time desc'

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "zone"
    self.attributes.to_xml(to_xml_opts)
  end
end