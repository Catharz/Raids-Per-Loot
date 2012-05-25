class Zone < ActiveRecord::Base
  belongs_to :difficulty, :inverse_of => :zones, :touch => true

  has_many :instances, :inverse_of => :zone
  has_many :drops, :inverse_of => :zone
  has_many :items, :through => :drops, :uniq => true
  has_many :mobs, :inverse_of => :zone

  has_one :last_instance,
      :class_name => 'Instance',
      :order => 'start_time desc'

  validates_presence_of :name
  validates_uniqueness_of :name

  def runs
    instances.count
  end

  def progression
    case difficulty.rating
      when 1 # Easy
        false
      when 2 # Normal
        runs < 10
      else   # Hard
        runs < 20
    end
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "zone"
    self.attributes.to_xml(to_xml_opts)
  end
end