jQuery ->
  $("select#drop_raid_id").change ->
    raid_id = $(this).val()
    filterInstancesForRaid(raid_id)
  $("select#drop_instance_id").change ->
    instance_id = $(this).val()
    filterZonesForInstance(instance_id)
  $("select#drop_zone_id").change ->
    zone_id = $(this).val()
    filterMobsForZone(zone_id)

filterInstancesForRaid = (raid_id) ->
  instance_select = $("select#drop_instance_id")
  instance_options_url = "/instances/option_list?raid_id=" + raid_id

  $("#instance_field").empty()
  $("#instance_field").append '<label class="header" for="drop_instance_id">Instance</label>'
  $instance_list = $('<select id="drop_instance_id" name="drop[instance_id]"></select>').appendTo '#instance_field'
  $("select#drop_instance_id").change ->
    instance_id = $(this).val()
    filterZonesForInstance(instance_id)
  $instance_list.load instance_options_url

filterZonesForInstance = (instance_id) ->
  zone_select = $("select#drop_zone_id")
  zone_options_url = "/zones/option_list?instance_id=" + instance_id

  $("#zone_field").empty()
  $("#zone_field").append '<label class="header" for="drop_zone_id">Zone</label>'
  $zone_list = $('<select id="drop_zone_id" name="drop[zone_id]"></select>').appendTo "#zone_field"
  $("select#drop_zone_id").change ->
    zone_id = $(this).val()
    filterMobsForZone(zone_id)
  $zone_list.load zone_options_url

filterMobsForZone = (zone_id) ->
  mob_select = $("select#drop_mob_id")
  mob_options_url = "/mobs/option_list?zone_id=" + zone_id

  $("#mob_field").empty()
  $("#mob_field").append '<label class="header" for="drop_mob_id">Mob</label>'
  $mob_list = $('<select id="drop_mob_id" name="drop[mob_id]"></select>').appendTo '#mob_field'
  $mob_list.load mob_options_url