jQuery ->
  $("#tabBook").tabs()
  $("#subTabBook").tabs()
  $("#character_loot_tabs").tabs()
  $("#character_loot_tabs").bind "tabselect", (event, ui) ->
    # This will hide and then show the players column in these tables forcing
    # them to resize before making all but the active characters visible
    #$("#btn_charactersLootTable_#{@char_type}_col_0").click()
    #$("#btn_charactersLootTable_#{@char_type}_col_0").click()
    #$("#charactersLootTable_#{@char_type}").dataTable().fnAdjustColumnSizing()
    debugger;

    if event.options.selected == 0
      $("#charactersLootTable_m").dataTable().fnAdjustColumnSizing()
      alert "raid mains"
    else
      $("#charactersLootTable_r").dataTable().fnAdjustColumnSizing()
      alert "raid alts"
    true
