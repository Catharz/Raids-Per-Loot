select name, instances_count, raids_count
from characters
where player_id is null
order by name;

select * from characters where player_id is null and instances_count > 0 or raids_count > 0;

update characters
set player_id = (select id from players where players.name = characters.name)
where player_id is null;

insert into players (name, rank_id)
(select name, 1 from characters where player_id is null and (raids_count > 0 or instances_count > 0));