oTable = $('#dataTable').dataTable()
aPos = oTable.fnGetPosition( document.getElementById("archetype_<%= @archetype.id %>") )
oTable.fnDeleteRow(aPos)
oTable.fnDraw()
$("#notice").empty().append("Class was successfully deleted.")