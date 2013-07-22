redrawTable = (char_type) ->
  oTable = $("#charactersTable_#{char_type}").dataTable()
  oTable.fnDraw()

redrawTable("<%= @character.char_type %>")
redrawTable('all')
displayFlash('notice', 'Character was successfully deleted.')