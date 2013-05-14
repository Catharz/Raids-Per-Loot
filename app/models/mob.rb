class Mob < ActiveRecord::Base
  belongs_to :zone, :inverse_of => :mobs, :touch => true
  belongs_to :difficulty, :inverse_of => :mobs, :touch => true
  has_many :drops, :inverse_of => :mob
  has_many :items, :through => :drops, :uniq => true

  has_one :last_drop, :class_name => 'Drop', :order => 'drop_time desc'
  has_one :first_drop, :class_name => 'Drop', :order => 'drop_time'

  validates_presence_of :name

  delegate :name, to: :zone, prefix: :zone, allow_nil: true
  delegate :name, to: :difficulty, prefix: :difficulty, allow_nil: true

  scope :by_zone, ->(zone_id) {
    zone_id ? where(:zone_id => zone_id) : scoped
  }
  scope :by_name, ->(name) {
    name ? where(:name => name) : scoped
  }

  def kills
    Instance.by_zone(zone_id).includes(:drops).where('drops.mob_id = ?', id).count
  end

  def last_killed
    last_drop ? last_drop.drop_time.strftime('%Y-%m-%d') : 'Never'
  end

  def first_killed
    first_drop ? first_drop.drop_time.strftime('%Y-%m-%d') : 'Never'
  end

  def is_progression?
    progression ? 'Yes' : 'No'
  end

  def progression
    progression = true
    unless difficulty.nil?
      progression =
          case difficulty.rating
            when 1 # Easy
              false
            when 2 # Normal
              kills < 10
            else   # Hard
              kills < 20
          end
    end
    progression
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "mob"
    self.attributes.to_xml(to_xml_opts)
  end
end
