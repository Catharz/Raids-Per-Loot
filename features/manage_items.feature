Feature: Manage items
  In order to assign Loot
  The raid leader
  wants to have a list of Items
  
  Background: Logged In
    Given I am logged in as a user

  Scenario: Register new item
    Given I am on the new item page
    When I fill in "Name" with "name 1"
    And I fill in "Eq2 item" with "eq2_item_id 1"
    And I fill in "Info url" with "info_url 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "eq2_item_id 1"
    And I should see "info_url 1"
    And I should see "Item was successfully created"

  @javascript
  Scenario: Delete item
    Given the following items:
      |name|eq2_item_id|info_url|
      |name 1|eq2_item_id 1|info_url 1|
      |name 2|eq2_item_id 2|info_url 2|
      |name 3|eq2_item_id 3|info_url 3|
      |name 4|eq2_item_id 4|info_url 4|
    When I delete the 3rd item
    Then I should see the following items:
      |Name|
      |name 1|
      |name 2|
      |name 4|
