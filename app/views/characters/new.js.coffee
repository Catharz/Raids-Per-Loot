characterPath = (character) ->
  if character.id == null
    character.name
  else
    "<a href=\"/characters/#{character.id}\" data-remote=\"true\">#{character.name}</a>"

insertCharacter = (character, char_type) ->
  oTable = $("#charactersTable_#{char_type}").dataTable()
  aRow = oTable.fnAddData([
    characterPath(character),
    characterPath(character.main_character.character),
    character.archetype_name,
    character.archetype_root,
    'Never',
    'Never',
    '0.00',
    '0.00',
    '0.00',
    "<a href='/characters/#{character.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/characters/#{character.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/characters/#{character.id}/fetch_data' class='table-button'>Update</a>",
    "<a href='/characters/#{character.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'character_' + character.id + '_' + char_type)
  aNode.setAttribute('data-raids', 0)
  aNode.setAttribute('data-instances', 0)
  aNode.setAttribute('data-armour', 0)
  aNode.setAttribute('data-weapon', 0)
  aNode.setAttribute('data-jewellery', 0)
  $(".table-button").button()
  oTable.fnDraw()
  #TODO: Get jQuery.ready to call the popup methods

$("#popup").dialog
  autoOpen: true
  width: 350
  modal: true
  resizable: false
  title: 'New Character'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/characters.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertCharacter(data.character, data.character.char_type)
          insertCharacter(data.character, 'all')
          $("#notice").empty().append("Character was successfully created.")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()