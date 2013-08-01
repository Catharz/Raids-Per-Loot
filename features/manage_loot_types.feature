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
    Then I should see loot type named: name 1
    And I should see the notice message: Loot type was successfully created

  Scenario: Delete loot_type
    Given I have the following loot types:
      | name   |
      | name 1 |
      | name 2 |
      | name 3 |
      | name 4 |
    When I delete the name 3 loot type
    Then I should see the following loot types:
      | Name   |
      | name 1 |
      | name 2 |
      | name 4 |

  @javascript
  Scenario: Changing the default loot method
    Given I have the following loot types:
      | name      | default_loot_method |
      | Armour    | n                   |
      | Body Drop | n                   |
    And the following drops:
      | zone        | mob        | character        | item        | loot_type | eq2_item_id   | drop_time                 | loot_method |
      | zone_name 1 | mob_name 1 | character_name 1 | item_name 1 | Armour    | eq2_item_id 1 | 2011-09-21 20:45:00 +1000 | n           |
      | zone_name 2 | mob_name 2 | character_name 2 | item_name 2 | Body Drop | eq2_item_id 2 | 2011-09-20 20:30:00 +1000 | n           |
    When I change the default loot method of Body Drop to Trash
    And the loot type items updater is run
    And I view the drops page
    And I wait until the table is rendered
    Then I should see the following drops:
      | Item Name   | Character Name   | Loot Type | Zone Name   | Mob Name   | Drop Time                 | Loot Method |
      | item_name 1 | character_name 1 | Armour    | zone_name 1 | mob_name 1 | 2011-09-21T20:45:00+10:00 | Need        |
      | item_name 2 | character_name 2 | Body Drop | zone_name 2 | mob_name 2 | 2011-09-20T20:30:00+10:00 | Trash       |
