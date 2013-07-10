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

updateCharacter = (character) ->
  $.get "/characters/#{character.id}.json", (data, text, xhr) ->
    if (xhr.status == 200)
      character = data.character
      oTable = $("charactersLootTable_#{character.char_type}").dataTable()
      aPos = oTable.fnGetPosition( document.getElementById("character_#{character.id}_#{character.char_type}") )
      oTable.fnUpdate(character.player_name, aPos, 0)
      oTable.fnUpdate(character.armour_rate.toFixed(2), aPos, 4)
      oTable.fnUpdate(character.weapon_rate.toFixed(2), aPos, 5)
      oTable.fnUpdate(character.jewellery_rate.toFixed(2), aPos, 6)
      oTable.fnUpdate(character.attuned_rate.toFixed(2), aPos, 7)
      oTable.fnUpdate(character.adornment_rate.toFixed(2), aPos, 8)
      oTable.fnUpdate(character.dislodger_rate.toFixed(2), aPos, 9)
      oTable.fnUpdate(character.mount_rate.toFixed(2), aPos, 10)
      oTable.fnDraw()

$('#popup').dialog
  autoOpen: true
  width: 380
  height: 300
  modal: true
  resizable: false
  title: 'Edit Player'
  buttons:
    'Cancel': ->
      $('#popup').dialog 'close'
    'Save': ->
      $.post "/players/<%= @player.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          if $('#playersTable').dataTable() > 0
            updatePlayer(data.player)
          if $('charactersLootTable_m').dataTable() > 0
            updateCharacter(data.player.current_main)
          if $('charactersLootTable_r').dataTable() > 0
            updateCharacter(data.player.current_raid_alternate)
          $('#notice').empty().append('Player was successfully updated.')
          $('#popup').dialog 'close'
  open: ->
    $('#popup').html "<%= escape_javascript(render('form')) %>"
    $('.actions').empty()