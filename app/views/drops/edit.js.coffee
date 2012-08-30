updateDropTableColumns = (drop, oTable, aPos) ->
  oTable.fnUpdate(drop.character_name, aPos, 0)
  oTable.fnUpdate(drop.character_archetype_name, aPos, 1)
  oTable.fnUpdate(drop.loot_type_name, aPos, 2)
  oTable.fnUpdate(drop.loot_method_name, aPos, 6)
  if (drop.invalid_reason == "")
    oTable.fnDeleteRow( aPos )
  else
    oTable.fnUpdate(drop.invalid_reason, aPos, 8)
  oTable.fnDraw()

updateInvalidDrop = (drop) ->
  oTable = $('#invalidDropsTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("drop_#{drop.id}") )
  $.get "/drops/#{drop.id}.json", (data, text, xhr) ->
    if (xhr.status == 200)
      updateDropTableColumns(data.drop, oTable, aPos)

$("#edit-invalid-drop-form").dialog
  autoOpen: true
  height: 460
  width: 380
  modal: true
  resizable: false
  title: 'Edit Drop'
  buttons:
    "Cancel": ->
      $("#edit-invalid-drop-form").dialog "close"
    "Save": ->
      $.post "/drops/<%= @drop.id %>.json", $("#edit-invalid-drop-form form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          updateInvalidDrop(data.drop)
          $("#notice").empty().append("Drop updated successfully")
          $("#edit-invalid-drop-form").dialog "close"
  open: ->
    $("#edit-invalid-drop-form").html "<%= escape_javascript(render('dialog_form')) %>"