oTable = $('#adjustmentsTable').dataTable()
aPos = oTable.fnGetPosition( document.getElementById("adjustment_<%= @adjustment.id %>") )
oTable.fnDeleteRow(aPos)
oTable.fnDraw()
$("#notice").empty().append("Adjustment was successfully deleted.")