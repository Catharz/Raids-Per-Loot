Feature: Manage link_categories
  In order to categorize links
  The site administrator
  wants a way of managing link categories
  
  Background: Need to login
    Given I am logged in as a user

  Scenario: Register new link_category
    Given I am on the new link_category page
    When I fill in "Title" with "title 1"
    And I fill in "Description" with "description 1"
    And I press "Create"
    Then I should see the link category titled: title 1
    And I should see the link category description: description 1
    And I should see the notice message: Link category was successfully created

  Scenario: Delete link_category
    Given I have the following link categories:
      |title|description|
      |title 1|description 1|
      |title 2|description 2|
      |title 3|description 3|
      |title 4|description 4|
    When I delete the link category title 3
    Then I should see the following link categories:
      |Title|Description|
      |title 1|description 1|
      |title 2|description 2|
      |title 4|description 4|
