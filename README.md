[![Build Status](https://travis-ci.org/Catharz/Raids-Per-Loot.png)](https://travis-ci.org/Catharz/Raids-Per-Loot)

Raids Per Loot
==============

The Raids Per Loot system has been created as a means to distribute loot in guilds lacking a consistent raid force.

[Southern Cross](http://southerncrossguild.guildlaunch.com),
is one of those guilds.

As guild and raid leader, I wanted a loot system with the following characteristics:

* Participation is rewarded in a transparent and consistent manner.
* Frequency of participation doesn't negatively impact chances of getting loot.
* Waiting for "better loot" to drop should neither be encouraged or discouraged.
* Players should be able to choose to raid with two characters, as a means of improving raid force flexibility without sacrificing loot system fairness or raid force viability.

We previously used the /random command to distribute loot, and while it met the 2nd and 3rd criteria, it didn't meet the other criteria.
We also tried a watered down DKP system, but it failed on all but the 1st criteria.

RaidsPerLoot meets all of the above criteria by distributing loot via the following formula:

    # raids / (# items looted + 1)

This formula is calculated separately for each item type (Weapon, Armour and Jewellery) at the player and character level.

While we use this system for EverQuest 2, all of the reference values can be modified at run-time to suit any game.

However, this system also uses [Sony's data API](http://data.soe.com/) to retrieve character and item statistics.  This code would need to be modified for games other than EQ2.