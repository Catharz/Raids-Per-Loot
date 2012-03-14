Feature: Manage drops
  In order to assign loot
  The raid leader
  wants a list of drops to assign

  Background: Need to login
    Given I am logged in as a user

  Scenario: Register new drop
    Given I am on the new drop page
    When I fill in "Zone name" with "zone_name 1"
    And I fill in "Mob name" with "mob_name 1"
    And I fill in "Player name" with "player_name 1"
    And I fill in "Item name" with "item_name 1"
    And I fill in "Eq2 item" with "eq2_item_id 1"
    And I select "16/09/2011 20:15:00" as the "Drop time" date and time
    And I press "Create"
    Then I should see "zone_name 1"
    And I should see "mob_name 1"
    And I should see "player_name 1"
    And I should see "item_name 1"
    And I should see "eq2_item_id 1"
    And I should see "2011-09-16 20:15:00 +1000"
    And I should see "Drop was successfully created"

  #NOTE: The drops table is ALWAYS sorted in reverse drop time order
  Scenario: Delete drop
    Given the following drops:
      |zone_name|mob_name|player_name|item_name|eq2_item_id|drop_time|
      |zone_name 1|mob_name 1|player_name 1|item_name 1|eq2_item_id 1|2011-09-21 20:45:00 +1000|
      |zone_name 2|mob_name 2|player_name 2|item_name 2|eq2_item_id 2|2011-09-20 20:30:00 +1000|
      |zone_name 3|mob_name 3|player_name 3|item_name 3|eq2_item_id 3|2011-09-19 20:15:00 +1000|
      |zone_name 4|mob_name 4|player_name 4|item_name 4|eq2_item_id 4|2011-09-18 20:00:00 +1000|
    When I delete the 3rd drop
    Then I should see the following drops:
      |Zone name|Mob name|Player name|Item name|Drop time|
      |zone_name 1|mob_name 1|player_name 1|item_name 1|2011-09-21 20:45:00 +1000|
      |zone_name 2|mob_name 2|player_name 2|item_name 2|2011-09-20 20:30:00 +1000|
      |zone_name 4|mob_name 4|player_name 4|item_name 4|2011-09-18 20:00:00 +1000|