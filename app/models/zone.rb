class Zone < ActiveRecord::Base
  belongs_to :difficulty, :inverse_of => :zones, :touch => true

  has_many :instances, :inverse_of => :zone
  has_many :drops, :inverse_of => :zone
  has_many :items, :through => :drops, :uniq => true
  has_many :mobs, :inverse_of => :zone

  has_one :last_instance,
      :class_name => 'Instance',
      :order => 'start_time desc'

  has_one :first_instance,
          :class_name => 'Instance',
          :order => 'start_time'

  validates_presence_of :name
  validates_uniqueness_of :name

  delegate :name, to: :difficulty, prefix: :difficulty, allow_nil: true

  scope :by_name, ->(name) {
    name ? where('name = ?', name) : scoped
  }

  def first_run
    first_instance ? first_instance.start_time.to_date : 'Never'
  end

  def last_run
    last_instance ? last_instance.start_time.to_date : 'Never'
  end

  def is_progression?
    progression ? 'Yes' : 'No'
  end

  def runs
    instances.count
  end

  def progression
    progression = true
    unless difficulty.nil?
      progression =
          case difficulty.rating
            when 1 # Easy
              false
            when 2 # Normal
              runs < 10
            else   # Hard
              runs < 20
          end
    end
    progression
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