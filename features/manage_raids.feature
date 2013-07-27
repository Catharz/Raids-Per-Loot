Feature: Manage raids
  In order to record Player attendance
  The raid leader
  wants to store a list of Raids

  Background: Need to login, and have a valid zone
    Given I am logged in as a user
    And the following zones:
      | name        | difficulty |
      | zone_name 1 | easy       |
    And the following raid types:
      | name        | raid_counted | raid_points | loot_counted | loot_cost |
      | Progression | true         | 2.0         | true         | 2.0       |

  Scenario: Register new raid
    Given I am on the new raid page
    When I enter 2011-09-19 as the raid date
    And I select Progression as the raid type
    And I press "Create"
    Then I should see "2011-09-19"
    And I should see "Progression"
    And I should see "Raid was successfully created"

  Scenario: Delete raid
    Given the following raids:
      | raid_date  |
      | 2011-09-18 |
      | 2011-09-21 |
      | 2011-09-23 |
      | 2011-09-24 |
    When I delete the raid on 2011-09-23
    Then I should see the following raids:
      | Raid date  |
      | 2011-09-18 |
      | 2011-09-21 |
      | 2011-09-24 |
