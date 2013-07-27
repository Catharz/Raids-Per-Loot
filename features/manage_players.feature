Feature: Manage players
  In order to assign Loot
  The raid leader
  wants Players to assign it to

  Background: Logged In
    Given I am logged in as a user

  @ranks
  @javascript
  Scenario: Register new player
    Given I am on the new player page
    When I enter name 1 as the player's name
    And I select Main as the player's rank
    And I press "Create"
    Then I should see "name 1"
    And I should see "Main"
    And I should see "Player was successfully created"

  @ranks
  Scenario: Delete player
    Given the following players:
      | name   |
      | name 1 |
      | name 2 |
      | name 3 |
      | name 4 |
    When I delete the player named name 3
    Then I should see the following players:
      | Name   |
      | name 1 |
      | name 2 |
      | name 4 |

  @ranks
  Scenario: Player's Loot Rates
    Given the following players:
      | name | raids_count |
      | Fred |           2 |
    And the following characters:
      | player | name  | armour_count | jewellery_count | weapons_count | adornments_count | dislodgers_count | mounts_count |
      | Fred   | Barny |            5 |               4 |             2 |                3 |                1 |            0 |
    And the following player attendance:
      | player | character | archetype | raid_date  | instances |
      | Fred   | Barny     | Scout     | 2012-01-01 | 2         |
    Then I should see the following players:
      | Name | Rank | First Raid | Last Raid  | Armour Rate | Jewellery Rate | Weapon Rate |
      | Fred | Main | 2012-01-01 | 2012-01-01 | 2.0         | 2.0            | 2.0         |