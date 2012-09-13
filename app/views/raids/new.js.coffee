insertRaid = (raid) ->
  oTable = $('#raidsTable').dataTable()
  aRow = oTable.fnAddData([
    raid.raid_date,
    raid.instances.length,
    raid.players.length,
    raid.characters.length,
    raid.kills.length,
    raid.drops.length,
    "<a href='/raids/#{raid.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/raids/#{raid.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/raids/#{raid.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  console.log 'row added'
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'raid_' + raid.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 850
  height: 600
  modal: true
  resizable: false
  title: 'New Raid'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/raids.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertRaid(data.raid)
          $("#notice").empty().append("Raid was successfully created.")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
    $("#datepicker").datepicker
      dateFormat: 'yy-mm-dd'
    $(".table-button").button()
    $(".button").button()
