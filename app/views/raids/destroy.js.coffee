oTable = $('#raidsTable').dataTable()
aPos = oTable.fnGetPosition( document.getElementById("raid_<%= @raid.id %>") )
oTable.fnDeleteRow(aPos)
oTable.fnDraw()
displayFlash('notice', 'Raid was successfully deleted.')