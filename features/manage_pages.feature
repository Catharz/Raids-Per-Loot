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
    Then I should see the page named: name 1
    And I should see the page title: title 1
    And I should see the page navigation label: navlabel 1
    And I should see the page body: body 1
    And I should see the notice message: Page was successfully created

  Scenario: Delete page
    Given I have the following pages:
      | name   | title   | navlabel   | body   | admin |
      | name 1 | title 1 | navlabel 1 | body 1 | true  |
      | name 2 | title 2 | navlabel 2 | body 2 | false |
      | name 3 | title 3 | navlabel 3 | body 3 | false |
      | name 4 | title 4 | navlabel 4 | body 4 | true  |
    When I delete the name 3 page
    Then I should see the following pages:
      | Name   | Title   | Nav Label  | Body          | Admin? |
      | name 1 | title 1 | navlabel 1 | <p>body 1</p> | Yes    |
      | name 2 | title 2 | navlabel 2 | <p>body 2</p> | No     |
      | name 4 | title 4 | navlabel 4 | <p>body 4</p> | Yes    |
