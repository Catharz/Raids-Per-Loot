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
    Then I should see the item called: name 1
    And I should see the item id: eq2_item_id 1
    And I should see the item url: info_url 1
    And I should see the notice message: Item was successfully created

  @javascript
  Scenario: Delete item
    Given the following items:
      | name   | eq2_item_id   | info_url   |
      | name 1 | eq2_item_id 1 | info_url 1 |
      | name 2 | eq2_item_id 2 | info_url 2 |
      | name 3 | eq2_item_id 3 | info_url 3 |
      | name 4 | eq2_item_id 4 | info_url 4 |
    When I delete the 3rd item
    Given I wait until the table is rendered
    Then I should see the following items:
      | Name   | Slot(s) | Class(es) |
      | name 1 | None    | None      |
      | name 2 | None    | None      |
      | name 4 | None    | None      |
