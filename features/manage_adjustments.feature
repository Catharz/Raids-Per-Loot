Feature: Manage Adjustments
  In Order to reconcile loot totals
  The raid leader needs to
  Adjust statistics for players and characters

  Background: Logged in
    Given I am logged in as a user

  @ranks
  @javascript
  Scenario: Creating a Player Adjustment
    Given the following players:
      | name     |
      | player 1 |
    And the following characters:
      | name        | char_type | player   |
      | character 1 | m         | player 1 |
      | character 2 | m         | player 1 |
    When I am on the new adjustment page
    And I select to adjust the Player named player 1
    And I enter 2012-01-15 as the adjustment date
    And I select Raids as the adjustment type
    And I select 23 as the adjusted amount
    And I save the adjustment
    Then I should see "Player"
    And I should see "player 1"
    And I should see "2012-01-15"
    And I should see "Raids"
    And I should see "23"

  @ranks
  @javascript
  Scenario: Creating a Character Adjustment
    Given the following players:
      | name     |
      | player 1 |
    And the following characters:
      | name        | char_type | player   |
      | character 1 | m         | player 1 |
      | character 2 | m         | player 2 |
    When I am on the new adjustment page
    And I select to adjust the Character named character 1
    And I enter 2012-01-15 as the adjustment date
    And I select Instances as the adjustment type
    And I select 32 as the adjusted amount
    And I save the adjustment
    Then I should see "Character"
    And I should see "character 1"
    And I should see "2012-01-15"
    And I should see "Instances"
    And I should see "32"

  @ranks
  @javascript
  Scenario: Changing Adjusted Entity
    Given the following characters:
      | name        | char_type | player   |
      | character 1 | m         | player 1 |
    And the following adjustments:
      | adjusted | type  | amount | name     | date       |
      | Player   | Raids | 56     | player 1 | 2012-05-15 |
    When I edit the 1st adjustment for the Player named player 1
    And I change the adjustable entity to Character
    And I change the adjusted entity to character 1
    And I save the adjustment
    Then I should see "Adjustment was successfully updated"
    And I should see "Character"
    And I should see "character 1"
    And I should see "2012-05-15"
    And I should see "Raids"
    And I should see "56"
