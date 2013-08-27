updatePlayer = (player) ->
  oTable = $('#playersTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("player_#{player.id}") )
  oTable.fnUpdate(player.name, aPos, 0)
  oTable.fnUpdate(player.rank_name, aPos, 1)
  oTable.fnUpdate(player.first_raid_date, aPos, 2)
  oTable.fnUpdate(player.last_raid_date, aPos, 3)
  oTable.fnUpdate(player.armour_rate.toFixed(2), aPos, 4)
  oTable.fnUpdate(player.jewellery_rate.toFixed(2), aPos, 5)
  oTable.fnUpdate(player.weapon_rate.toFixed(2), aPos, 6)
  oTable.fnDraw()

$('#popup').dialog
  autoOpen: true
  width: 380
  height: 330
  modal: true
  resizable: false
  title: 'Edit Player'
  buttons:
    'Cancel': ->
      $('#popup').dialog 'close'
    'Save': ->
      $.post "/players/<%= @player.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        updatePlayer(data.player)
        displayFlash 'notice', 'Player was successfully updated.'
        $('#popup').dialog 'close'
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $('#popup').html "<%= escape_javascript(render('form')) %>"
    $('.actions').empty()