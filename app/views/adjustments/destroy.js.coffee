oTable = $('#adjustmentsTable').dataTable()
aPos = oTable.fnGetPosition( document.getElementById("adjustment_<%= @adjustment.id %>") )
oTable.fnDeleteRow(aPos)
$("#notice").empty().append("Adjustment was successfully deleted.")