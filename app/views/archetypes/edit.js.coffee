updateArchetype = (archetype) ->
  oTable = $('#dataTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("archetype_#{archetype.id}") )
  oTable.fnUpdate(archetype.name, aPos, 0)
  oTable.fnUpdate(archetype.parent_name, aPos, 1)
  oTable.fnUpdate(archetype.root_name, aPos, 2)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 350
  modal: true
  resizable: false
  title: 'Edit Class'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/archetypes/<%= @archetype.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        updateArchetype data.archetype
        displayFlash 'notice', 'Archetype was successfully updated.'
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
        displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()