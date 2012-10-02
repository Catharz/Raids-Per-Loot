class PlayerRaid < ActiveRecord::Base
  belongs_to :player, inverse_of: :player_raids, touch: true
  belongs_to :raid, inverse_of: :player_raids, touch: true

  validates_format_of :status, :with => /a|b/ # Attended, Benched
end