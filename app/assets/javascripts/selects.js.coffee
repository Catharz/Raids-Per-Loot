jQuery ->
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