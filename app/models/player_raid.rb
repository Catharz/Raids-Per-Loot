# @author Craig Read
#
# PlayerRaid resolves the many-to-many relationship
# between a Player and the Raids they attend.
# This also allows storage of attendance related
# statistics, such as whether they signed up
# or were punctual.
class PlayerRaid < ActiveRecord::Base
  belongs_to :player, inverse_of: :player_raids, touch: true
  belongs_to :raid, inverse_of: :player_raids, touch: true

  validates_presence_of :raid_id, :player_id
  validates_uniqueness_of :player_id, :scope => :raid_id
  validates_format_of :status, :with => /a|b/ # Attended, Benched

  delegate :name, to: :player, prefix: :player
  delegate :description, to: :raid, prefix: :raid

  scope :by_player, ->(player_id = nil) {
    player_id ? where(player_id: player_id) : scoped
  }
  scope :by_raid, ->(raid_id = nil) {
    raid_id ? where(raid_id: raid_id) : scoped
  }

  def status_description
    @status_types ||= {a: 'Attended', b: 'Benched'}.with_indifferent_access
    @status_types[status]
  end
end