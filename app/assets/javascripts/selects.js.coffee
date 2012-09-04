decorateSelects = () ->
  $("select#adjustment_adjustable_type").change ->
    adjustable_type = $(this).val()
    adjustable_select = $(this).next 'select'
    options_url = ""

    if adjustable_type == "Player"
      options_url = "/players/option_list"
    else
      options_url = "/characters/option_list"

    $("#adjustable_field").empty()
    $("#adjustable_field").append "<strong>" + adjustable_type + ":</strong> "
    $adjustables = $('<select id="adjustment_adjustable_id" name="adjustment[adjustable_id]"></select>').appendTo '#adjustable_field'
    $adjustables.load options_url

  $("select#drop_zone_id").change ->
    zone_id = $(this).val()
    mob_select = $("select#drop_mob_id")
    mob_options_url = "/mobs/option_list?zone_id=" + zone_id

    $("#mob_field").empty()
    $("#mob_field").append "<strong>Mob</strong></br>"
    $mob_list = $('<select id="drop_mob_id" name="drop[mob_id]"></select>').appendTo '#mob_field'
    $mob_list.load mob_options_url

jQuery ->
  decorateSelects()