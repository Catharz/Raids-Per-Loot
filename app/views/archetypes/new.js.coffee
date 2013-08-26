insertArchetype = (archetype) ->
  oTable = $('#dataTable').dataTable()
  aRow = oTable.fnAddData([
    archetype.name,
    archetype.parent_name,
    archetype.root_name,
    "<a href='/archetypes/#{archetype.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/archetypes/#{archetype.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/archetypes/#{archetype.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'archetype_' + archetype.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 350
  modal: true
  resizable: false
  title: 'New Archetype'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/archetypes.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        insertArchetype data.archetype
        displayFlash 'notice', 'Archetype was successfully created.'
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
        displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()