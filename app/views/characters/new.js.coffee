redrawTable = (char_type) ->
  oTable = $("#charactersTable_#{char_type}").dataTable()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 400
  height: 520
  modal: true
  resizable: false
  title: 'New Character'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/characters.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        redrawTable(data.character.char_type)
        redrawTable('all')
        displayFlash('notice', 'Character was successfully created.')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".datepicker").datepicker
      dateFormat: 'yy-mm-dd'
    $(".actions").empty()