Feature: Manage loot_types
  In order to categorise loot
  The Raid Leader
  wants a list of loot types
  
  Background: Logged In
    Given I am logged in as a user

  Scenario: Register new loot_type
    Given I am on the new loot_type page
    When I fill in "Name" with "name 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "Loot type was successfully created"

  Scenario: Delete loot_type
    Given the following loot_types:
      |name|
      |name 1|
      |name 2|
      |name 3|
      |name 4|
    When I delete the 3rd loot_type
    Then I should see the following loot_types:
      |Name|
      |name 1|
      |name 2|
      |name 4|
