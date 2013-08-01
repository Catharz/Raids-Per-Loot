Feature: Manage slots
  In order to identify loot
  The raid leader
  wants to know what slot loot goes in
  
  Background: Logged In
    Given I am logged in as a user

  Scenario: Register new slot
    Given I am on the new slot page
    When I fill in "Name" with "name 1"
    And I press "Create"
    Then I should see the slot named: name 1
    And I should see the notice message: Slot was successfully created

  Scenario: Delete slot
    Given the following slots:
      |name|
      |name 1|
      |name 2|
      |name 3|
      |name 4|
    When I delete the name 3 slot
    Then I should see the following slots:
      |Name|
      |name 1|
      |name 2|
      |name 4|
