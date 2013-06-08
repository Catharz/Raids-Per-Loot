redrawTable = (char_type) ->
  oTable = $("#charactersTable_#{char_type}").dataTable()
  oTable.fnDraw()

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
          redrawTable(data.character.char_type)
          redrawTable('all')
          $("#notice").empty().append("Character was successfully created.")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()