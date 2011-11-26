Feature: Manage mobs
  In order to identify Loot
  The raid leader
  wants a list of Mobs the loot comes from

  Background: Need to login
    Given I am logged in as a user

  Scenario: Register new mob
    Given the following zones:
      |name|
      |zone_name 1|
    Given I am on the new mob page
    When I fill in "Name" with "name 1"
    And I fill in "Strategy" with "strategy 1"
    And I select "zone_name 1" from "mob_zone_ids"
    And I press "Create"
    Then I should see "name 1"
    And I should see "strategy 1"
    And I should see "Mob was successfully created"

  Scenario: Delete mob
    Given the following mobs:
      |name|strategy|zone_name|
      |name 1|strategy 1|zone_name 1|
      |name 2|strategy 2|zone_name 2|
      |name 3|strategy 3|zone_name 3|
      |name 4|strategy 4|zone_name 4|
    When I delete the 3rd mob
    Then I should see the following mobs:
      |Zone|Name|Strategy|
      |zone_name 1|name 1|strategy 1|
      |zone_name 2|name 2|strategy 2|
      |zone_name 4|name 4|strategy 4|
