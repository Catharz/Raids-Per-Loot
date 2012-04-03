Feature: Manage players
  In order to assign Loot
  The raid leader
  wants Players to assign it to

  Background: Logged In
    Given I am logged in as a user

  @ranks
  Scenario: Register new player
    Given I am on the new player page
    When I fill in "Name" with "name 1"
    And I select "Main" from "Rank"
    And I press "Create"
    Then I should see "name 1"
    And I should see "Main"
    And I should see "Player was successfully created"

  @ranks
  Scenario: Delete player
    Given the following players:
      |name|
      |name 1|
      |name 2|
      |name 3|
      |name 4|
    When I delete the 3rd player
    Then I should see the following players:
      |Name|
      |name 1|
      |name 2|
      |name 4|
