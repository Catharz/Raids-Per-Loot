Feature: Manage zones
  In order to identify Loot
  The raid leader
  wants each raid to be associated with a Zone
  
  Background: Logged In
    Given I am logged in as a user

  Scenario: Create new zone
    Given I am on the new zone page
    When I fill in "Name" with "name 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "Zone was successfully created"

  Scenario: Delete zone
    Given the following zones:
      |name|
      |name 1|
      |name 2|
      |name 3|
      |name 4|
    When I delete the 3rd zone
    Then I should see the following zones:
      |Name|
      |name 1|
      |name 2|
      |name 4|
