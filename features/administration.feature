Feature: Site Administration
  In Order facilitate loot distribution
  The raid leader needs to
  Perform administration functions

  Background: Logged in
    Given I am logged in as a user

  Scenario: Updating Item Details
    When I go to the admin page
    Then I should see "Welcome to the Admin page"
    And I should see "Update All Item Details"
