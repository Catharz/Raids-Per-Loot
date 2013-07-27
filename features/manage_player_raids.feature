Feature: Manage player_raids
  In order to record attendance details
  The site administrator
  wants a way of associating players with raids

  Background: Need to login
    Given I am logged in as a user
    And the following players:
      | name     |
      | player 1 |
      | player 2 |
    And the following raids:
      | raid_date  |
      | 2012-09-18 |
      | 2012-09-21 |

  Scenario: Register new player_raid
    Given I am on the new player_raid page
    When I select "player 1" as the player
    And I select "2012-09-18 (Progression)" as the raid
    And I press "Create"
    Then I should see "player 1"
    And I should see "2012-09-18 (Progression)"
    And I should see "Player raid was successfully created"

  Scenario: Delete player_raid
    Given the following player_raids:
      | raid_date  | raid_type   | player   | signed_up | punctual | status |
      | 2012-09-18 | Progression | player 1 | true      | true     | a      |
      | 2012-09-18 | Progression | player 2 | true      | true     | b      |
      | 2012-09-21 | Progression | player 1 | true      | true     | b      |
      | 2012-09-21 | Progression | player 2 | true      | true     | a      |
    When I delete the player raid for player 1 on 2012-09-21
    Then I should see the following player_raids:
      | Raid                     | Player   | Signed Up | Punctual | Status   |
      | 2012-09-18 (Progression) | player 1 | true      | true     | Attended |
      | 2012-09-18 (Progression) | player 2 | true      | true     | Benched  |
      | 2012-09-21 (Progression) | player 2 | true      | true     | Attended |
