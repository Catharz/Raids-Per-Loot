Feature: Manage archetypes
  In order to correctly assign loot
  The raid leader
  wants to be able to identify Players and Loot by Archetype
  
  Background: Logged In
    Given I am logged in as a user

  Scenario: Creating an archetype with a valid parent
    Given I have an archetype named Rogue
    And I have an archetype named Brigand
    When I am editing the archetype named Brigand
    And I set the parent archetype to Rogue
    And I click Update Archetype
    Then I should see "Archetype was successfully updated"

  Scenario: Setting an archetypes parent to itself
    Given I have an archetype named Scout
    When I am editing the archetype named Scout
    And I set the parent archetype to Scout
    And I click Update Archetype
    Then I should see "Cannot set an archetypes parent to itself"
    But I should not see "Archetype was successfully updated"

  Scenario: Creating archetype with circular parentage
    Given I have an archetype named Scout
    And I have an archetype named Brigand with a parent named Scout
    When I am editing the archetype named Scout
    And I set the parent archetype to Brigand
    And I click Update Archetype
    Then I should see "Cannot set an archetypes parent to one of its descendents"
    But I should not see "Archetype was successfully updated"