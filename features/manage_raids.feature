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
    When I select "zone_name 1" from "raid_zone_id"
    And I select "19/09/2011" as the "Raid date" date
    And I select "19/09/2011 20:00:00" as the "Start time" date and time
    And I select "19/09/2011 22:30:00" as the "End time" date and time
    And I press "Create"
    Then I should see "zone_name 1"
    And I should see "2011-09-19"
    And I should see "2011-09-19 20:00:00 +1000"
    And I should see "2011-09-19 22:30:00 +1000"
    And I should see "Raid was successfully created"

  Scenario: A raid cannot end before it starts
    Given I am on the new raid page
    When I select "zone_name 1" from "raid_zone_id"
    And I select "19/09/2011" as the "Raid date" date
    And I select "19/09/2011 22:30:00" as the "Start time" date and time
    And I select "19/09/2011 20:00:00" as the "End time" date and time
    And I press "Create"
    Then I should see "Raid must start before it ends"
    And I should not see "Raid was successfully created"

  Scenario: Delete raid
    Given the following raids:
      |zone_name|raid_date|start_time|end_time|
      |zone_name 1|2011-09-18|2011-09-18 15:00:00 +1000|2011-09-18 18:00:00 +1000|
      |zone_name 2|2011-09-21|2011-09-21 20:00:00 +1000|2011-09-21 22:30:00 +1000|
      |zone_name 3|2011-09-23|2011-09-23 20:00:00 +1000|2011-09-23 22:30:00 +1000|
      |zone_name 4|2011-09-24|2011-09-24 20:00:00 +1000|2011-09-24 22:30:00 +1000|
    When I delete the 3rd raid
    Then I should see the following raids:
      |Zone|Raid date|Start time|End time|
      |zone_name 1|2011-09-18|2011-09-18 15:00:00 +1000|2011-09-18 18:00:00 +1000|
      |zone_name 2|2011-09-21|2011-09-21 20:00:00 +1000|2011-09-21 22:30:00 +1000|
      |zone_name 4|2011-09-24|2011-09-24 20:00:00 +1000|2011-09-24 22:30:00 +1000|
