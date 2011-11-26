Feature: Manage archetypes
  In order to correctly assign loot
  The raid leader
  wants to be able to identify Players and Loot by Archetype
  
  Scenario: Register new archetype
    Given I am on the new archetype page
    When I fill in "Name" with "name 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "Archetype was successfully created"

  Scenario: Delete archetype
    Given the following archetypes:
      |name|
      |name 1|
      |name 2|
      |name 3|
      |name 4|
    When I delete the 3rd archetype
    Then I should see the following archetypes:
      |Name|
      |name 1|
      |name 2|
      |name 4|
