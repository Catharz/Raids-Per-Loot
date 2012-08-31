class Raid < ActiveRecord::Base
  has_many :instances, :inverse_of => :raid
  has_many :kills, :through => :instances, :uniq => true
  has_many :players, :through => :instances, :uniq => true
  has_many :characters, :through => :instances, :uniq => true
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

  def benched_players
    ids = Adjustment.where(adjustment_date: raid_date, adjustment_type: 'Raid', adjustable_type: 'Player').collect! { |a| a.adjustable_id }
    Player.find(ids)
  end

  def add_benched_player(player)
    unless benched_players.include? player
      adjustment = Adjustment.create(adjustment_date: raid_date, adjustment_type: 'Raid', adjustable_type: 'Player', adjustable_id: player.id, amount: 1)
      adjustment.save
    end
  end

  def self.for_period(range = {start:  nil, end: nil})
    raids = scoped
    raids = where('raid_date >= ?', range[:start]) if range[:start]
    raids = where('raid_date <= ?', range[:end]) if range[:end]
    raids
  end

  def self.by_date(date)
    date ? where(:raid_date => date) : scoped
  end
end