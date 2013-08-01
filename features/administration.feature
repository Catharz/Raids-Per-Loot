Feature: Site Administration
  In Order facilitate loot distribution
  The raid leader needs to
  Perform administration functions

  Background: Logged in
    Given I am logged in as a user

  Scenario: Updating Item Details
    When I go to the admin page
    Then I should see the heading: Welcome to the Admin page
    And I should see a link titled: Update All Item Details
    And I should see a link titled: Update All Character Details
