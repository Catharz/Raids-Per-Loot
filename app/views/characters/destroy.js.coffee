oTable = $("#charactersTable_<%= @character.char_type %>").dataTable()
aPos = oTable.fnGetPosition( document.getElementById("character_<%= @character.id %>_<%= @character.char_type %>") )
oTable.fnDeleteRow(aPos)

oTable = $("#charactersTable_all").dataTable()
aPos = oTable.fnGetPosition( document.getElementById("character_<%= @character.id %>_all") )
oTable.fnDeleteRow(aPos)

oTable.fnDraw()
$("#notice").empty().append("Character was successfully deleted.")