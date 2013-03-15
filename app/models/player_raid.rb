class PlayerRaid < ActiveRecord::Base
  belongs_to :player, inverse_of: :player_raids, touch: true
  belongs_to :raid, inverse_of: :player_raids, touch: true

  validates_presence_of :raid_id, :player_id
  validates_uniqueness_of :player_id, :scope => :raid_id
  validates_format_of :status, :with => /a|b/ # Attended, Benched

  delegate :name, to: :player, prefix: :player
  delegate :description, to: :raid, prefix: :raid

  def self.by_player(player_id = nil)
    player_id ? where(player_id: player_id) : scoped
  end

  def self.by_raid(raid_id = nil)
    raid_id ? where(raid_id: raid_id) : scoped
  end

  def status_description
    @status_types ||= {a: 'Attended', b: 'Benched'}.with_indifferent_access
    @status_types[status]
  end
end