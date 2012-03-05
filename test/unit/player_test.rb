require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  def test_should_create_player
    assert_difference 'Player.count' do
      create_player
    end
  end

  def test_loot_rate_equals_raids_when_no_loot
    # Arrange
    player = create_player()
    num_raids = 3
    num_items = 0

    # Act
    expected = 3
    actual = player.calculate_loot_rate(num_raids, num_items)

    # Assert
    assert_equal(expected, actual, "The loot rate should equal the number of raids when they player has 0 items")
  end

  protected
    def create_player(options = {})
      Factory.create(:player, {:name => 'Humpty'}.merge(options))
    end
end