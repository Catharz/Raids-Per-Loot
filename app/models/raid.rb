class Raid < ActiveRecord::Base
  has_many :instances, inverse_of: :raid, dependent: :destroy
  has_many :kills, through: :instances, uniq: true
  has_many :character_instances, through: :instances
  has_many :characters, through: :character_instances, uniq: true
  has_many :player_raids, inverse_of: :raid
  has_many :players, through: :player_raids, uniq: true
  has_many :drops, through: :instances

  accepts_nested_attributes_for :instances, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :player_raids, reject_if: :all_blank, allow_destroy: true

  def benched_players
    players.includes(:player_raids).where("player_raids.status = ?", 'b')
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