class Raid < ActiveRecord::Base
  has_many :instances, :inverse_of => :raid
  has_many :kills, :through => :instances
  has_many :players, :through => :instances
  has_many :characters, :through => :instances
  has_many :drops, :through => :instances

  accepts_nested_attributes_for :instances, :reject_if => :all_blank, :allow_destroy => true

  def raid_description
    raid_date.to_s + ': ' + zone.name
  end

  def zone_name
    if zone
      zone.name
    else
      "Unknown"
    end
  end

  def self.by_date(date)
    date ? where('raid_date = ?', date) : scoped
  end

  def self.utc_time(date_time)
    TZInfo::Timezone.get('Australia/Melbourne').utc_time(date_time)
  end

  def self.local_time(date_time)
    TZInfo::Timezone.get('Australia/Melbourne').local_time(date_time)
  end
end