Feature: Manage characters
  In order to assign loot
  The raid leader
  Wants characters to assign it to

  Background: Need to login and have some valid defaults
    Given I am logged in as a user
    And I have a player named Newbie
    And I have an archetype named Monk

  @ranks
  Scenario: Register new character
    Given I am on the new character page
    When I select "Newbie" as the characters player
    And I enter "name 1" as the characters name
    And I select "Monk" as the characters class
    And I choose "Main" as the character type
    And I save the character
    Then I should see "name 1"
    And I should see "Monk"
    And I should see "Main"
    And I should see "Character was successfully created"

  Scenario: Showing a character with drops
    Given I have a Main character named Betty
    And the following drops:
      | zone        | mob        | character | item        | loot_type | eq2_item_id   | drop_time                 |
      | zone_name 1 | mob_name 1 | Betty     | item_name 1 | Armour    | eq2_item_id 1 | 2011-09-21 20:45:00 +1000 |
      | zone_name 2 | mob_name 2 | Betty     | item_name 2 | Weapon    | eq2_item_id 2 | 2011-09-20 20:30:00 +1000 |
    When I view the characters page for Betty
    Then I should see the following character drops:
      | Item Name   | Mob Name   | Loot Type | Drop Time                 | Character Name | Loot Method |
      | item_name 1 | mob_name 1 | Armour    | 2011-09-21 20:45:00 +1000 | Betty          | Need        |
      | item_name 2 | mob_name 2 | Weapon    | 2011-09-20 20:30:00 +1000 | Betty          | Need        |
