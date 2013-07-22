insertCharacterType = (character_type) ->
  oTable = $('#characterTypesTable').dataTable()
  aRow = oTable.fnAddData([
    character_type.player_name,
    character_type.character_name,
    character_type.effective_date,
    character_type.character_first_raid_date,
    character_type.character_last_raid_date,
    character_type.character_type_name,
    character_type.normal_penalty,
    character_type.progression_penalty,
    "<a href='/character_types/#{character_type.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/character_types/#{character_type.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/character_types/#{character_type.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'character_type_' + character_type.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  height: 300
  width: 390
  modal: true
  resizable: false
  title: 'New Character Type'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/character_types.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertCharacterType(data.character_type)
          displayFlash('notice', 'Character_type was successfully created.')
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $("#datepicker").datepicker
      dateFormat: 'yy-mm-dd'
    $(".actions").empty()