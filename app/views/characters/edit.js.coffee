redrawTable = (character) ->
  if $("#charactersTable_#{character.char_type}").dataTable().length > 0
    oTable = $("#charactersTable_#{character.char_type}").dataTable()
    oTable.fnDraw()
  if $("#charactersLootTable_#{character.char_type}").dataTable().length > 0
    oTable = $("#charactersLootTable_#{character.char_type}").dataTable()
    aPos = oTable.fnGetPosition( document.getElementById("character_#{character.id}_#{character.char_type}") )
    oTable.fnUpdate(character.player_name, aPos, 0)
    oTable.fnUpdate(yesNo(character.player_active), aPos, 1)
    oTable.fnUpdate(character.name, aPos, 2)
    oTable.fnUpdate(character.archetype_name, aPos, 3)
    oTable.fnUpdate(character.archetype_root, aPos, 4)
    oTable.fnUpdate(character.armour_rate.toFixed(2), aPos, 5)
    oTable.fnUpdate(character.jewellery_rate.toFixed(2), aPos, 6)
    oTable.fnUpdate(character.weapon_rate.toFixed(2), aPos, 7)
    oTable.fnUpdate(character.attuned_rate.toFixed(2), aPos, 8)
    oTable.fnUpdate(character.adornment_rate.toFixed(2), aPos, 9)
    oTable.fnUpdate(character.dislodger_rate.toFixed(2), aPos, 10)
    oTable.fnUpdate(character.mount_rate.toFixed(2), aPos, 11)
    oTable.fnUpdate(character.switch_rate.toFixed(2), aPos, 12)
    oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 450
  height: 470
  modal: true
  resizable: false
  title: 'Edit Character'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/characters/<%= @character.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          redrawTable(data.character)
          redrawTable('all')
          displayFlash('notice', 'Character was successfully updated.')
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()