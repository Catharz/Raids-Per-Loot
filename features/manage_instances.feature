Feature: Manage instances
  In order to record Player attendance
  The raid leader
  wants to store a list of Instances

  Background: Need to login, and have a valid zone
    Given I am logged in as a user
    And the following zones:
      | name        | difficulty |
      | zone_name 1 | Easy       |
    And the following raids:
      | raid_date  |
      | 2011-09-18 |

  Scenario: Register new instance
    Given I am on the new instance page
    When I select "2011-09-18" as the instance's Raid
    And I select "18/09/2011 20:00:00" as the "Start time" date and time
    And I select zone_name 1 as the instance's Zone
    And I press "Create"
    Then I should see "2011-09-18"
    And I should see "20:00:00"
    And I should see "zone_name 1"
    And I should see "Instance was successfully created"

  #TODO Resolve the issue of MY time zone appearing in the tests
  Scenario: Delete instance
    Given the following instances:
      | start_time          | zone           |
      | 2011-09-18 20:00:00 | Here           |
      | 2011-09-21 20:00:00 | There          |
      | 2011-09-23 20:00:00 | Everywhere     |
      | 2011-09-24 20:00:00 | Somewhere Else |
    When I delete the 3rd instance
    Then I should see the following instances:
      | Start time                | Zone           |
      | 2011-09-18 20:00:00 +1000 | Here           |
      | 2011-09-21 20:00:00 +1000 | There          |
      | 2011-09-24 20:00:00 +1000 | Somewhere Else |
