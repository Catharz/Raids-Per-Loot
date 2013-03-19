[![Build Status](https://travis-ci.org/Catharz/Raids-Per-Loot.png)](https://travis-ci.org/Catharz/Raids-Per-Loot)

Raids Per Loot
==============

The Raids Per Loot system has been created as a means to distribute loot guilds lacking a consistent raid force.

[Southern Cross](http://southerncross.guildportal.com), is one of those guilds.
As guild leader and raid leader, I wanted a loot system with the following characteristics:

* Participation must be rewarded consistently
* Frequency of participation should not negatively impact chances of getting loot
* Waiting for "better loot" to drop should neither be encouraged or discouraged
* Players should be able to choose to raid with two characters without disrupting the fairness of the loot system or sacrifice the viability of the raid force

We previously used the /random command to distribute loot, and while it met the 2nd and 3rd criteria, it didn't meet the other.
We also tried a watered down DKP system, but it failed on all but the 1st and 3rd criteria.

RaidsPerLoot meets all of the above criteria in a transparent manner.

The formula used for determining loot priority is: "# raids / (# items looted + 1)".
This formula is calculated separately for each drop category (Weapon, Armour and Jewellery).

The system caters for loot for main characters and alternates, along with ranks for each player.
While we use this system for EverQuest 2, values such as player classes, player ranks, item slots and drop categories can be modified to suit any game.
However, the system also use [Sony's data API](http://data.soe.com/) to retrieve character statistics.  This code would need to be modified for other games.