Feature: Manage drops
  In order to assign loot
  The raid leader
  wants a list of drops to assign

  Background: Need to login and have some valid defaults
    Given I am logged in as a user
    And I have a zone named Wherever
    And I have a Main character named Newbie
    And I have a mob named Bad Ass Dragon from Wherever
    And I have a Weapon item named Can O' Whoop Ass with id 1234
    And I have a Wherever raid at "2011-09-16 20:15:00 +1000"

  @javascript
  Scenario: Create a valid Needed drop
    Given I am on the new drop page
    When I select Wherever as the Zone
    And I select Bad Ass Dragon as the Mob
    And I select Newbie as the Character
    And I select Can O' Whoop Ass as the Item
    And I select Weapon as the Loot Type
    And I select "16/09/2011 20:15:00" as the "Drop time" date and time
    And I select a loot method of Need
    And I fill in "Chat" with "blah, blah, blah"
    And I press "Create"
    Then I should see "Wherever"
    And I should see "Bad Ass Dragon"
    And I should see "Can O' Whoop Ass"
    And I should see "2011-09-16 20:15:00 +1000"
    And I should see "Need"
    And I should see "blah, blah, blah"
    And I should see "Drop was successfully created"

#NOTE: The drops table is sorted in reverse drop time order (by default)

  @javascript
  Scenario: Delete drop
    Given the following drops:
      | zone        | mob        | character        | item        | loot_type | eq2_item_id   | drop_time                 | loot_method |
      | zone_name 1 | mob_name 1 | character_name 1 | item_name 1 | Armour    | eq2_item_id 1 | 2011-09-21 20:45:00 +1000 | n           |
      | zone_name 2 | mob_name 2 | character_name 2 | item_name 2 | Weapon    | eq2_item_id 2 | 2011-09-20 20:30:00 +1000 | r           |
      | zone_name 3 | mob_name 3 | character_name 3 | item_name 3 | Jewellery | eq2_item_id 3 | 2011-09-19 20:15:00 +1000 | b           |
      | zone_name 4 | mob_name 4 | character_name 4 | item_name 4 | Trash     | eq2_item_id 4 | 2011-09-18 20:00:00 +1000 | t           |
    When I delete the 3rd drop
    Given I wait until tbody tr is visible
    Then I should see the following drops:
      | Item Name   | Character Name   | Loot Type | Zone Name   | Mob Name   | Drop Time                 | Loot Method |
      | item_name 1 | character_name 1 | Armour    | zone_name 1 | mob_name 1 | 2011-09-21T20:45:00+10:00 | Need        |
      | item_name 2 | character_name 2 | Weapon    | zone_name 2 | mob_name 2 | 2011-09-20T20:30:00+10:00 | Random      |
      | item_name 4 | character_name 4 | Trash     | zone_name 4 | mob_name 4 | 2011-09-18T20:00:00+10:00 | Trash       |

  @javascript
  Scenario: Invalid Drops
    Given the following drops:
      | zone        | mob        | character        | item        | loot_type | eq2_item_id   | drop_time                 | loot_method |
      | zone_name 1 | mob_name 1 | character_name 1 | item_name 1 | Armour    | eq2_item_id 1 | 2011-09-21 20:45:00 +1000 | t           |
      | zone_name 2 | mob_name 2 | character_name 2 | item_name 2 | Weapon    | eq2_item_id 2 | 2011-09-20 20:30:00 +1000 | t           |
      | zone_name 3 | mob_name 3 | character_name 3 | item_name 3 | Trash     | eq2_item_id 3 | 2011-09-19 20:15:00 +1000 | n           |
      | zone_name 4 | mob_name 4 | character_name 4 | item_name 4 | Weapon    | eq2_item_id 4 | 2011-09-18 20:00:00 +1000 | t           |
    When I view the invalid drops page
    Then I should see the following invalid drops:
      | Character        | Class | Drop Type | Item Type | Item Name   | Item Classes | Loot Method | Drop Time                 | Invalid Reason                    |
      | character_name 1 | Scout | Armour    | Armour    | item_name 1 | None         | Trash       | 2011-09-21 20:45:00 +1000 | Loot via Trash for Non-Trash item |
      | character_name 2 | Scout | Weapon    | Weapon    | item_name 2 | None         | Trash       | 2011-09-20 20:30:00 +1000 | Loot via Trash for Non-Trash item |
      | character_name 3 | Scout | Trash     | Trash     | item_name 3 | None         | Need        | 2011-09-19 20:15:00 +1000 | Loot via Need for Trash Item      |
      | character_name 4 | Scout | Weapon    | Weapon    | item_name 4 | None         | Trash       | 2011-09-18 20:00:00 +1000 | Loot via Trash for Non-Trash item |
