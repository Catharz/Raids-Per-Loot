Feature: Manage raids
  In order to record Player attendance
  The raid leader
  wants to store a list of Raids

  Background: Need to login, and have a valid zone
    Given I am logged in as a user
    And the following zones:
      |name|
      |zone_name 1|

  Scenario: Register new raid
    Given I am on the new raid page
    When I enter 2011-09-19 as the raid date
    And I press "Create"
    Then I should see "2011-09-19"
    And I should see "Raid was successfully created"

  Scenario: Delete raid
    Given the following raids:
      |raid_date|
      |2011-09-18|
      |2011-09-21|
      |2011-09-23|
      |2011-09-24|
    When I delete the 3rd raid
    Then I should see the following raids:
      |Raid date|
      |2011-09-18|
      |2011-09-21|
      |2011-09-24|
