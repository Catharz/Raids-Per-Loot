insertInstance = (instance) ->
  oTable = $('#instancesTable').dataTable()
  aRow = oTable.fnAddData([
    instance.zone_name,
    instance.start_time,
    instance.players.length,
    instance.characters.length,
    instance.kills.length,
    instance.drops.length,
    "<a href='/instances/#{instance.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/instances/#{instance.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/instances/#{instance.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'instance_' + instance.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 500
  height: 460
  modal: true
  resizable: false
  title: 'New Instance'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/instances.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        insertInstance(data.instance)
        displayFlash('notice', 'Instance was successfully created.')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()