@difficulty
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
    And I select "zone_name 1" from "mob_zone_id"
    And I fill in "Alias" with "alias 1"
    And I fill in "Strategy" with "strategy 1"
    And I select "Easy" from "mob_difficulty_id"
    And I press "Create"
    Then I should see "name 1"
    And I should see "strategy 1"
    And I should see "Mob was successfully created"

  Scenario: Delete mob
    Given I have the following mobs:
      |zone_name  |name  |alias  |difficulty|
      |zone_name 1|name 1|alias 1|Easy      |
      |zone_name 2|name 2|alias 2|Normal    |
      |zone_name 3|name 3|alias 3|Hard      |
      |zone_name 4|name 4|alias 4|Easy      |
    When I delete the mob name 3
    Then I should see the following mobs:
      |Zone|Name|Alias|
      |zone_name 1|name 1|alias 1|
      |zone_name 2|name 2|alias 2|
      |zone_name 4|name 4|alias 4|
