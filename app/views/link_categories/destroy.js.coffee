oTable = $('#dataTable').dataTable()
aPos = oTable.fnGetPosition( document.getElementById("link_category_<%= @link_category.id %>") )
oTable.fnDeleteRow(aPos)
oTable.fnDraw()
displayFlash('notice', 'Link category was successfully deleted.')