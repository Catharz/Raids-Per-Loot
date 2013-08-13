Feature: Managing Raid Loot
  In order to distribute loot fairly
  The raid leader
  Wants to update players and characters

  Background: Base setup
    Given I am logged in as a user

  @ranks
  @archetypes

  @javascript
  Scenario: Smoke Test
    Given the following player characters:
      | player | active | character | char_type | confirmed      | confirmed_date | class       | raids | armour | jewellery | weapons | adornments | dislodgers | mounts |
      | Fred   | yes    | Fred      | m         | optimal        | 2013-03-21     | Monk        | 2     | 1      | 2         | 0       | 0          | 0          | 0      |
      | Fred   | yes    | Wilma     | r         | minimum        | 2013-03-25     | Troubador   | 2     | 0      | 1         | 0       | 0          | 0          | 0      |
      | Barney | yes    | Barney    | m         | optimal        | 2013-04-01     | Defiler     | 1     | 0      | 1         | 1       | 0          | 0          | 0      |
      | Barney | yes    | Betty     | r         | optimal        | 2013-05-16     | Necromancer | 1     | 0      | 0         | 0       | 1          | 0          | 0      |
      | Barney | yes    | Bam Bam   | g         | unsatisfactory | 2013-03-01     | Dirge       | 1     | 0      | 0         | 0       | 0          | 0          | 0      |
    When I go to the loot page
    Then I should see the following raid mains:
      | Player | Character | Class   | Armour | Jewellery | Weapon | Average |
      | Barney | Barney    | Defiler | 1.00   | 0.50      | 0.50   | 0.33    |
      | Fred   | Fred      | Monk    | 1.00   | 0.67      | 2.00   | 0.50    |
    And I should see the following raid alternates:
      | Player | Character | Class       | Armour | Jewellery | Weapon | Average |
      | Barney | Betty     | Necromancer | 1.00   | 1.00      | 1.00   | 1.00    |
      | Fred   | Wilma     | Troubador   | 2.00   | 1.00      | 2.00   | 1.00    |
