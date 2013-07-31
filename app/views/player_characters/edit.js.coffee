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

updateCharacter = (character) ->
  oTable = $("#charactersLootTable_#{character.char_type}").dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("character_#{character.id}_#{character.char_type}") )
  oTable.fnUpdate(yesNo(character.player_active), aPos, 1)
  oTable.fnUpdate(character.confirmed_date, aPos, 3)
  oTable.fnUpdate(character.armour_rate.toFixed(2), aPos, 5)
  oTable.fnUpdate(character.jewellery_rate.toFixed(2), aPos, 6)
  oTable.fnUpdate(character.weapon_rate.toFixed(2), aPos, 7)
  oTable.fnUpdate(character.attuned_rate.toFixed(2), aPos, 8)
  oTable.fnUpdate(character.adornment_rate.toFixed(2), aPos, 9)
  oTable.fnUpdate(character.dislodger_rate.toFixed(2), aPos, 10)
  oTable.fnUpdate(character.mount_rate.toFixed(2), aPos, 11)
  oTable.fnUpdate(character.player_switch_rate.toFixed(2), aPos, 12)
  updateCharacterDataAttributes(character)
  oTable.fnDraw()

$('#popup').dialog
  autoOpen: true
  width: 380
  height: 520
  modal: true
  resizable: false
  title: "Editing Loot Stats"
  buttons:
    'Cancel': ->
      $('#popup').dialog 'close'
    'Save': ->
      $.post "/player_characters/<%= @player_character.character.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          if $('#charactersLootTable_m').dataTable().length > 0
            $.get "/characters/#{data.main_character.character.id}.json", (data, text, xhr) ->
              if (xhr.status == 200)
                updateCharacter(data.character)
          if $('#charactersLootTable_r').dataTable().length > 0
            unless data.raid_alternate == null or data.raid_alternate.character == null
              $.get "/characters/#{data.raid_alternate.character.id}.json", (data, text, xhr) ->
                if (xhr.status == 200)
                  updateCharacter(data.character)
          $('#notice').empty().append('Loot Stats successfully updated.')
          $('#popup').dialog 'close'
  open: ->
    $('#popup').html "<%= escape_javascript(render('form')) %>"
    $(".datepicker").datepicker
      dateFormat: 'yy-mm-dd'
    $('.actions').empty()