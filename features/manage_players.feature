Feature: Manage players
  In order to assign Loot
  The raid leader
  wants Players to assign it to

  Background: Logged In
    Given I am logged in as a user

  @ranks
  Scenario: Register new player
    Given I am on the new player page
    When I fill in "Name" with "name 1"
    And I select "Main" from "Rank"
    And I press "Create"
    Then I should see "name 1"
    And I should see "Main"
    And I should see "Player was successfully created"

  @ranks
  Scenario: Delete player
    Given the following players:
      |name|
      |name 1|
      |name 2|
      |name 3|
      |name 4|
    When I delete the 3rd player
    Then I should see the following players:
      |Name|
      |name 1|
      |name 2|
      |name 4|

  @ranks
  @loot_types
  Scenario: Loot Rate With No Adjustments
    Given the following player attendance:
      |player|character|archetype|raid_date |instances|
      |Fred  |Barny    |Scout    |2012-01-01|2        |
    And the following drops:
      |zone  |mob  |player|character|item  |loot_type|eq2_item_id  |drop_time                |
      |zone 1|mob 1|Fred  |Barny    |item 1|Armour   |eq2_item_id 1|2011-09-21 20:45:00 +1000|
      |zone 2|mob 2|Fred  |Barny    |item 2|Weapon   |eq2_item_id 2|2011-09-20 20:30:00 +1000|
      |zone 3|mob 3|Fred  |Barny    |item 3|Armour   |eq2_item_id 3|2011-09-19 20:15:00 +1000|
      |zone 4|mob 4|Fred  |Barny    |item 4|Weapon   |eq2_item_id 4|2011-09-18 20:00:00 +1000|
    Then I should see the following players:
      |Name |Rank|Characters|First Raid|Last Raid |# Raids|# Instances|Armour Rate|Jewellery Rate|Weapon Rate|
      |Fred |Main|Characters|2012-01-01|2012-01-01|1      |2          |0.33       |1.0           |0.33       |

  @ranks
  @loot_types
  Scenario: Loot Rate With Adjusted Raids
    Given the following player attendance:
      |player|character|archetype|raid_date |instances|
      |Fred  |Barny    |Scout    |2012-01-02|3        |
    And the following player adjustments:
      |date      |type|amount|player|
      |2012-01-01|raid|2     |Fred  |
    And the following drops:
      |zone  |mob  |player|character|item  |loot_type|eq2_item_id  |drop_time                |
      |zone 1|mob 1|Fred  |Barny    |item 1|Armour   |eq2_item_id 1|2011-09-21 20:45:00 +1000|
      |zone 2|mob 2|Fred  |Barny    |item 2|Weapon   |eq2_item_id 2|2011-09-20 20:30:00 +1000|
      |zone 3|mob 3|Fred  |Barny    |item 3|Armour   |eq2_item_id 3|2011-09-19 20:15:00 +1000|
      |zone 4|mob 4|Fred  |Barny    |item 4|Weapon   |eq2_item_id 4|2011-09-18 20:00:00 +1000|
    Then I should see the following players:
      |Name |Rank|Characters|First Raid|Last Raid |# Raids|# Instances|Armour Rate|Jewellery Rate|Weapon Rate|
      |Fred |Main|Characters|2012-01-02|2012-01-02|3      |3          |1.0        |3.0           |1.0        |

  @ranks
  @loot_types
  Scenario: Loot Rate With Adjusted Armour
    Given the following player attendance:
      |player|character|archetype|raid_date |instances|
      |Fred  |Barny    |Scout    |2012-01-02|3        |
    And the following player adjustments:
      |date      |type  |amount|player|
      |2012-01-01|Armour|2     |Fred  |
    And the following drops:
      |zone  |mob  |player|character|item  |loot_type|eq2_item_id  |drop_time                |
      |zone 1|mob 1|Fred  |Barny    |item 1|Armour   |eq2_item_id 1|2011-09-21 20:45:00 +1000|
      |zone 2|mob 2|Fred  |Barny    |item 2|Weapon   |eq2_item_id 2|2011-09-20 20:30:00 +1000|
      |zone 3|mob 3|Fred  |Barny    |item 3|Armour   |eq2_item_id 3|2011-09-19 20:15:00 +1000|
      |zone 4|mob 4|Fred  |Barny    |item 4|Weapon   |eq2_item_id 4|2011-09-18 20:00:00 +1000|
    Then I should see the following players:
      |Name |Rank|Characters|First Raid|Last Raid |# Raids|# Instances|Armour Rate|Jewellery Rate|Weapon Rate|
      |Fred |Main|Characters|2012-01-02|2012-01-02|1      |3          |0.2        |1.0           |0.33       |

  @ranks
  @loot_types
  Scenario: Loot Rate With Adjusted Jewellery
    Given the following player attendance:
      |player|character|archetype|raid_date |instances|
      |Fred  |Barny    |Scout    |2012-01-02|3        |
    And the following player adjustments:
      |date      |type     |amount|player|
      |2012-01-01|Jewellery|2     |Fred  |
    And the following drops:
      |zone  |mob  |player|character|item  |loot_type|eq2_item_id  |drop_time                |
      |zone 1|mob 1|Fred  |Barny    |item 1|Armour   |eq2_item_id 1|2011-09-21 20:45:00 +1000|
      |zone 2|mob 2|Fred  |Barny    |item 2|Weapon   |eq2_item_id 2|2011-09-20 20:30:00 +1000|
      |zone 3|mob 3|Fred  |Barny    |item 3|Armour   |eq2_item_id 3|2011-09-19 20:15:00 +1000|
      |zone 4|mob 4|Fred  |Barny    |item 4|Weapon   |eq2_item_id 4|2011-09-18 20:00:00 +1000|
    Then I should see the following players:
      |Name |Rank|Characters|First Raid|Last Raid |# Raids|# Instances|Armour Rate|Jewellery Rate|Weapon Rate|
      |Fred |Main|Characters|2012-01-02|2012-01-02|1      |3          |0.33       |0.33          |0.33       |