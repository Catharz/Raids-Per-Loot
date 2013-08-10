yesNo = (value) ->
  if value then "Yes" else "No"

insertMob = (mob) ->
  oTable = $('#mobsTable').dataTable()
  aRow = oTable.fnAddData([
    mob.name,
    mob.alias,
    mob.zone_name,
    mob.difficulty_name,
    mob.kills,
    mob.first_killed,
    mob.last_killed,
    yesNo(mob.progression),
    "<a href='/mobs/#{mob.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/mobs/#{mob.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/mobs/#{mob.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'mob_' + mob.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 450
  height: 500
  modal: true
  resizable: false
  title: 'New Mob'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/mobs.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertMob(data.mob)
          displayFlash('notice', 'Mob was successfully created.')
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
