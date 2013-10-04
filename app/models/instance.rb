# @author Craig Read
#
# Instance represents a 'Zone' instance when raiding.
class Instance < ActiveRecord::Base
  belongs_to :raid, inverse_of: :instances, touch: true
  belongs_to :zone, inverse_of: :instances, touch: true

  has_many :drops, :inverse_of => :instance, dependent: :destroy
  has_many :character_instances, :inverse_of => :instance, dependent: :destroy

  has_many :kills, :through => :drops, :source => :mob, :uniq => true
  has_many :characters, :through => :character_instances
  has_many :players, :through => :characters, :uniq => true

  has_one :last_drop, :class_name => 'Drop', :order => 'created_at desc'

  validates_presence_of :raid, :zone, :start_time
  validates_uniqueness_of :start_time, :scope => [:raid_id, :zone_id]

  delegate :name, :to => :zone, :prefix => :zone
  delegate :raid_date, :to => :raid

  scope :raided, ->(raid_date) {
    where(:raid_id => Raid.find_by_raid_date(raid_date).id)
  }
  scope :by_raid, ->(raid_id) {
    raid_id ? where('instances.raid_id = ?', raid_id) : scoped
  }
  scope :by_zone, ->(zone_id) {
    zone_id ? where('instances.zone_id = ?', zone_id) : scoped
  }
  scope :by_start_time, ->(time) {
    if time
      start_time = time.is_a?(String) ? Time.zone.parse(time) : time
      where(:start_time => start_time)
    else
      scoped
    end
  }
end
