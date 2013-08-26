updateCharacterType = (character_type) ->
  oTable = $('#characterTypesTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("character_type_#{character_type.id}") )
  oTable.fnUpdate(character_type.effective_date, aPos, 2)
  oTable.fnUpdate(character_type.character_type_name, aPos, 5)
  oTable.fnUpdate(character_type.normal_penalty, aPos, 6)
  oTable.fnUpdate(character_type.progression_penalty, aPos, 7)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  height: 300
  width: 390
  modal: true
  resizable: false
  title: 'Edit Character Type'
  buttons:
    "Cancel": ->
      $("#popup").html ""
      $("#popup").dialog "close"
    "Save": ->
      $.post "/character_types/<%= @character_type.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        updateCharacterType(data.character_type)
        displayFlash('notice', 'Character type updated successfully')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript( render('form') ) %>"
    $("#datepicker").datepicker
      dateFormat: 'yy-mm-dd'
    $(".actions").empty()