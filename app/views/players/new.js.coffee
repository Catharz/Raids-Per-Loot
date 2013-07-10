insertPlayer = (player) ->
  oTable = $('#playersTable').dataTable()
  aRow = oTable.fnAddData([
    player.name,
    player.rank_name,
    player.first_raid_date,
    player.last_raid_date,
    player.armour_rate,
    player.jewellery_rate,
    player.weapon_rate,
    "<a href='/players/#{player.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/players/#{player.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/players/#{player.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'player_' + player.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 380
  height: 300
  modal: true
  resizable: false
  title: 'New Player'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/players.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertPlayer(data.player)
          $("#notice").empty().append("Player was successfully created.")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()