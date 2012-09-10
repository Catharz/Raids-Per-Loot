Feature: Manage pages
  In order to make site content flexible
  The site administrator
  wants to be able to define Pages

  Background: Need to login
    Given I am logged in as a user

  Scenario: Register new page
    Given I am on the new page page
    When I fill in "Name" with "name 1"
    And I fill in "Title" with "title 1"
    And I fill in "Navlabel" with "navlabel 1"
    And I fill in "Body" with "body 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "title 1"
    And I should see "navlabel 1"
    And I should see "body 1"
    And I should see "Page was successfully created"

  Scenario: Delete page
    Given the following pages:
      | name   | title   | navlabel   | body   | admin |
      | name 1 | title 1 | navlabel 1 | body 1 | true  |
      | name 2 | title 2 | navlabel 2 | body 2 | false |
      | name 3 | title 3 | navlabel 3 | body 3 | false |
      | name 4 | title 4 | navlabel 4 | body 4 | true  |
    When I delete the 3rd page
    Then I should see the following pages:
      | Name   | Title   | Nav Label  | Body          | Admin? |
      | name 1 | title 1 | navlabel 1 | <p>body 1</p> | Yes    |
      | name 2 | title 2 | navlabel 2 | <p>body 2</p> | No     |
      | name 4 | title 4 | navlabel 4 | <p>body 4</p> | Yes    |
