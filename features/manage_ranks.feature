Feature: Manage ranks
  In order to hand out loot fairly
  The raid leader
  wants to be able to have player ranks

  Background: Logged In
    Given I am logged in as a user

  Scenario: Register new rank
    Given I am on the new rank page
    When I fill in "Name" with "name 1"
    And I fill in "Priority" with "1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "1"
    And I should see "Rank was successfully created"

  Scenario: Delete rank
    Given the following ranks:
      | name   | priority |
      | name 1 | 1        |
      | name 2 | 2        |
      | name 3 | 3        |
      | name 4 | 4        |
    When I delete the name 3 rank
    Then I should see the following ranks:
      | Name   | Priority |
      | name 1 | 1        |
      | name 2 | 2        |
      | name 4 | 4        |
