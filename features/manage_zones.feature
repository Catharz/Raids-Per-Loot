@difficulty
Feature: Manage zones
  In order to identify Loot
  The raid leader
  wants each raid to be associated with a Zone
  
  Background: Logged In
    Given I am logged in as a user

  Scenario: Create new zone
    Given I am on the new zone page
    When I fill in "Name" with "name 1"
    And I select "Easy" from "zone_difficulty_id"
    And I press "Create"
    Then I should see the zone named: name 1
    And I should see the notice message: Zone was successfully created

  Scenario: Delete zone
    Given the following zones:
      |name  |difficulty|
      |name 1|Easy      |
      |name 2|Normal    |
      |name 3|Hard      |
      |name 4|Normal    |
    When I delete the name 3 zone
    Then I should see the following zones:
      |Name|
      |name 1|
      |name 2|
      |name 4|
