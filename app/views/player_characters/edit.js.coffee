yesNo = (value) ->
  if value then "Yes" else "No"

updateCharacterDataAttributes = (character) ->
  rowData = $("#character_#{character.id}_#{character.char_type}").data()
  rowData.player_raids = character.player_raids_count
  rowData.armour = character.armour_count
  rowData.jewellery = character.jewellery_count
  rowData.weapons = character.weapons_count
  rowData.attuned = character.armour_count + character.jewellery_count + character.weapons_count
  rowData.adornments = character.adornments_count
  rowData.dislodgers = character.dislodgers_count
  rowData.mounts = character.mounts_count
  rowData.switches = character.player_switches_count
  true

updatePCCharacter = (character) ->
  oTable = $("#charactersLootTable_#{character.char_type}").dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("character_#{character.id}_#{character.char_type}") )
  oTable.fnUpdate(yesNo(character.player_active), aPos, 1)
  oTable.fnUpdate(character.confirmed_date, aPos, 3)
  oTable.fnUpdate(character.armour_rate.toFixed(2), aPos, 6)
  oTable.fnUpdate(character.jewellery_rate.toFixed(2), aPos, 7)
  oTable.fnUpdate(character.weapon_rate.toFixed(2), aPos, 8)
  oTable.fnUpdate(character.attuned_rate.toFixed(2), aPos, 9)
  oTable.fnUpdate(character.adornment_rate.toFixed(2), aPos, 10)
  oTable.fnUpdate(character.dislodger_rate.toFixed(2), aPos, 11)
  oTable.fnUpdate(character.mount_rate.toFixed(2), aPos, 12)
  oTable.fnUpdate(character.player_switch_rate.toFixed(2), aPos, 13)
  updateCharacterDataAttributes(character)
  oTable.fnDraw()
  true

$('#popup').dialog
  autoOpen: true
  width: 340
  height: 550
  modal: true
  resizable: false
  title: "Editing Loot Stats"
  buttons:
    'Cancel': ->
      $('#popup').dialog 'close'
    'Save': ->
      player = $("form.edit_player").serializeArray()
      character = $("form.edit_character").serializeArray()

      player_id = "<%= @player_character.player.id %>"
      character_id = "<%= @player_character.character.id %>"
      raid_main_id = "<%= @player_character.player.main_character.id %>"
      raid_alt_id = "<%= @player_character.player.raid_alternate.id %>"

      $.post "/players/#{player_id}.json", player, (data, text, xhr) ->
        $.post "/characters/#{character_id}.json", character, (data, text, xhr) ->
          if $('#charactersLootTable_m').dataTable().length > 0
            $.get "/characters/#{raid_main_id}.json", (data, text, xhr) ->
              if (xhr.status == 200)
                updatePCCharacter(data.character)
          if $('#charactersLootTable_r').dataTable().length > 0
            unless raid_alt_id == ""
              $.get "/characters/#{raid_alt_id}.json", (data, text, xhr) ->
                if (xhr.status == 200)
                  updatePCCharacter(data.character)
          $('#notice').empty().append('Loot Stats successfully updated.')
          $('#popup').dialog 'close'
        .fail (data, text, xhr) ->
            displayFlash 'error', parseErrors(data.responseJSON)
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
      true
  open: ->
    $('#popup').html "<%= escape_javascript(render('form')) %>"
    $(".datepicker").datepicker
      dateFormat: 'yy-mm-dd'
    $('.actions').empty()