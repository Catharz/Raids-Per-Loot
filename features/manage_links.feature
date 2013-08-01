Feature: Manage links
  In order to list links on the website
  The site administrator
  wants a way of managing links
  
  Background: Need to login
    Given I am logged in as a user

  Scenario: Register new link
    Given I am on the new link page
    When I fill in "Url" with "url 1"
    And I fill in "Title" with "title 1"
    And I fill in "Description" with "description 1"
    And I press "Create"
    Then I should see the link url: url 1
    And I should see the link titled: title 1
    And I should see the link description: description 1
    And I should see the notice message: Link was successfully created

  Scenario: Delete link
    Given I have the following links:
      |url|title|description|
      |url 1|title 1|description 1|
      |url 2|title 2|description 2|
      |url 3|title 3|description 3|
      |url 4|title 4|description 4|
    When I delete the link to url 3
    Then I should see the following links:
      |Url|Title|Description|
      |url 1|title 1|description 1|
      |url 2|title 2|description 2|
      |url 4|title 4|description 4|
