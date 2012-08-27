updateCharacterTypesTableColumns = (character_type, oTable, aPos) ->
  oTable.fnUpdate(character_type.effective_date, aPos, 2)
  oTable.fnUpdate(character_type.character_type_name, aPos, 5)
  oTable.fnUpdate(character_type.normal_penalty, aPos, 6)
  oTable.fnUpdate(character_type.progression_penalty, aPos, 7)
  oTable.fnDraw()

updateCharacterType = (character_type) ->
  oTable = $('#characterTypesTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("character_type_#{character_type.id}") )
  $.get "/character_types/#{character_type.id}.json", (data, text, xhr) ->
    if (xhr.status == 200)
      updateCharacterTypesTableColumns(data.character_type, oTable, aPos)

$("#popup-form").dialog
  autoOpen: true
  height: 400
  width: 400
  modal: true
  resizable: true
  title: 'Edit Character Type'
  buttons:
    "Cancel": ->
      $("#popup-form").html ""
      $("#popup-form").dialog "close"
    "Save": ->
      $.post "/character_types/<%= @character_type.id %>.json", $("#popup-form form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          updateCharacterType(data.character_type)
          $("#notice").empty().append("Character Type updated successfully")
          $("#popup-form").dialog "close"
  open: ->
    $("#popup-form").html "<%= escape_javascript( render('form') ) %>"
    $("#datepicker").datepicker
      dateFormat: 'yy-mm-dd'
    $(".actions").remove()