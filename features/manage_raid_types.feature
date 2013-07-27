Feature: Manage Raid types
  In order to assign Loot
  The raid leader
  wants to define types of raids

  Background: Logged In
    Given I am logged in as a user

  Scenario: Register new raid type
    Given I am on the new raid type page
    When I fill in "Name" with "name 1"
    And I check "Raid counted"
    And I fill in "Raid points" with "1.0"
    And I uncheck "Loot counted"
    And I fill in "Loot cost" with "0.0"
    And I press "Create"
    Then I should see "name 1"
    And I should see "true"
    And I should see "1.0"
    And I should see "false"
    And I should see "0.0"
    And I should see "Raid type was successfully created"

  Scenario: Delete raid type
    Given the following raid types:
      | name        | raid_counted | raid_points | loot_counted | loot_cost |
      | Progression | true         | 2.0         | true         | 2.0       |
      | Normal      | true         | 1.0         | true         | 1.0       |
      | Pickup      | false        | 0.0         | false        | 0.0       |
      | Trash       | false        | 0.5         | false        | 0.0       |
    When I delete the Pickup raid type
    Then I should see the following raid types:
      | Name        | Raid counted | Raid points | Loot counted | Loot cost |
      | Progression | true         | 2.0         | true         | 2.0       |
      | Normal      | true         | 1.0         | true         | 1.0       |
      | Trash       | false        | 0.5         | false        | 0.0       |