class PlayerRaid < ActiveRecord::Base
  belongs_to :player, inverse_of: :player_raids, touch: true
  belongs_to :raid, inverse_of: :player_raids, touch: true

  validates_uniqueness_of :player_id, :scope => :raid_id

  validates_format_of :status, :with => /a|b/ # Attended, Benched

  def self.by_player(player_id)
    player_id ? where(player_id: player_id) : scoped
  end

  def self.by_raid(raid_id)
    raid_id ? where(raid_id: raid_id) : scoped
  end
end