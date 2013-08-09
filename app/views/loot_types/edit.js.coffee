updateLootType = (loot_type) ->
  oTable = $('#dataTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("loot_type_#{loot_type.id}") )
  oTable.fnUpdate(loot_type.name, aPos, 0)
  oTable.fnUpdate(loot_type.default_loot_method_name, aPos, 1)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 300
  height: 240
  modal: true
  resizable: false
  title: 'Edit Loot Type'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/loot_types/<%= @loot_type.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          updateLootType(data.loot_type)
          displayFlash('notice', 'Loot Type was successfully updated.')
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
