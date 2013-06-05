characterPath = (character) ->
  if character.id == null
    character.name
  else
    "<a href=\"/characters/#{character.id}\" data-remote=\"true\">#{character.name}</a>"

updateCharacter = (character, char_type) ->
  oTable = $("#charactersTable_#{char_type}").dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("character_#{character.id}_#{char_type}") )
  oTable.fnUpdate(characterPath(character), aPos, 0)
  oTable.fnUpdate(characterPath(character.main_character.character), aPos, 1)
  oTable.fnUpdate(character.archetype_name, aPos, 2)
  oTable.fnUpdate(character.archetype_root, aPos, 3)
  oTable.fnUpdate(character.first_raid_date, aPos, 4)
  oTable.fnUpdate(character.last_raid_date, aPos, 5)
  oTable.fnUpdate(character.armour_rate.toFixed(2), aPos, 6)
  oTable.fnUpdate(character.jewellery_rate.toFixed(2), aPos, 7)
  oTable.fnUpdate(character.weapon_rate.toFixed(2), aPos, 8)
  # Need to update all of the character names for the edited character
  $("td#character_#{character.id} a").each (index) ->
    $(this).text(character.name)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 350
  height: 250
  modal: true
  resizable: false
  title: 'Edit Character'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/characters/<%= @character.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        console.log xhr.status
        if (xhr.status == 200)
          updateCharacter(data.character, 'all')
          updateCharacter(data.character, data.character.char_type)
          $("#notice").empty().append("Character was successfully updated.")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()