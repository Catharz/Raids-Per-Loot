update players
set raids_count = (
  select count(*)
  from player_raids
  where player_id = players.id
);

update players
set instances_count = (
  select count(distinct instance_id)
  from character_instances
  where character_id in (
    select id
    from characters
    where player_id = players.id
  )
);

update characters
set instances_count = (
  select count(*)
  from character_instances
  where character_id = characters.id
);

update characters
set raids_count = (
  select count(distinct raid_id)
  from player_raids
  where player_id = characters.player_id
);

insert into player_raids (player_id, raid_id) (
  select distinct chr.player_id, inst.raid_id
  from characters chr, instances inst, character_instances ci
  where chr.id = ci.character_id
  and inst.id = ci.instance_id
  and (chr.player_id, inst.raid_id) not in (select player_id, raid_id from player_raids)
  order by inst.raid_id, chr.player_id
);