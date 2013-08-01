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
    Then I should see the notice message: Archetype was successfully updated