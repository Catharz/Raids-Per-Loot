Feature: Manage slots
  In order to identify loot
  The raid leader
  wants to know what slot loot goes in
  
  Scenario: Register new slot
    Given I am on the new slot page
    When I fill in "Name" with "name 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "Slot was successfully created"

  Scenario: Delete slot
    Given the following slots:
      |name|
      |name 1|
      |name 2|
      |name 3|
      |name 4|
    When I delete the 3rd slot
    Then I should see the following slots:
      |Name|
      |name 1|
      |name 2|
      |name 4|
