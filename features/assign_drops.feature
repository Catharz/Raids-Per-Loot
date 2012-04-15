Feature: Manage drops
  In order to reward raiders
  The raid leader
  Needs to award loot fairly

  Background: Need to login
    Given I am logged in as a user

  Scenario: Assigning a valid drop
    Given I have a zone named Wherever
    And I have a Main character named Newbie
    And I have a mob named Bad Ass Dragon from Wherever
    And I have an item named Can O' Whoop Ass with id 1234
    And I have a Wherever raid at "2011-09-16 20:15:00 +1000"
    When I assign a drop named Can O' Whoop Ass to Newbie from Bad Ass Dragon in Wherever at "2011-09-16 20:15:00 +1000"
    Then I should see "Drop was successfully assigned"

  Scenario: Assigning a drop with an invalid zone name
    Given I have a zone named Wherever
    And I have a Raid Alternate character named Newbie
    And I have a mob named Bad Ass Dragon from Wherever
    And I have an item named Can O' Whoop Ass with id 3456
    And I have a Wherever raid at "2011-09-16 20:15:00 +1000"
    When I assign a drop named Can O' Whoop Ass to Newbie from Bad Ass Dragon in Nowhere at "2011-09-16 20:15:00 +1000"
    Then I should see "A valid zone must exist to be able to create drops for it"
    And I should not see "Drop was successfully assigned"

  Scenario: Assigning a drop with an invalid mob
    Given I have a zone named Wherever
    And I have a General Alternate character named Newbie
    And I have a mob named Bad Ass Dragon from Wherever
    And I have an item named Can O' Whoop Ass with id 3456
    And I have a Wherever raid at "2011-09-16 20:15:00 +1000"
    When I assign a drop named Can O' Whoop Ass to Newbie from Ugly Ass Dragon in Wherever at "2011-09-16 20:15:00 +1000"
    Then I should see "A mob must exist for the entered zone to be able to create drops for it"
    And I should not see "Drop was successfully asssigned"

  Scenario: Assigning a drop to an invalid character
    Given I have a zone named Wherever
    And I have a Main character named Newbie
    And I have a mob named Bad Ass Dragon from Wherever
    And I have an item named Can O' Whoop Ass with id 1234
    And I have a Wherever raid at "2011-09-16 20:15:00 +1000"
    When I assign a drop named Can O' Whoop Ass to Uber Monk from Bad Ass Dragon in Wherever at "2011-09-16 20:15:00 +1000"
    Then I should see "A valid character must exist to be able to assign drops to them"
    And I should not see "Drop was successfully assigned"

  Scenario: Drop with an invalid item name should not be assigned
    Given I have a zone named Wherever
    And I have a Raid Alternate character named Newbie
    And I have a mob named Bad Ass Dragon from Wherever
    And I have an item named Can O' Whoop Ass with id 1234
    And I have a Wherever raid at "2011-09-16 20:15:00 +1000"
    When I assign a drop named Can O' Dumb Ass to Newbie from Bad Ass Dragon in Wherever at "2011-09-16 20:15:00 +1000"
    Then I should see "A loot item must exist to be able to record it dropping"
    And I should not see "Drop was successfully assigned"

  Scenario: Drop with an invalid drop time should not be assigned
    Given I have a zone named Wherever
    And I have a General Alternate character named Newbie
    And I have a mob named Bad Ass Dragon from Wherever
    And I have an item named Can O' Whoop Ass with id 1234
    And I have a Wherever raid at "2011-09-16 20:15:00 +1000"
    When I assign a drop named Can O' Whoop Ass to Newbie from Bad Ass Dragon in Wherever at "2011-09-17 20:15:00 +1000"
    Then I should see "An instance must exist for the entered zone and drop time to be able to create drops for it"
    And I should not see "Drop was successfully assigned"

