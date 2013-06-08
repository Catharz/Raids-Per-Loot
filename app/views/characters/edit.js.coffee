redrawTable = (char_type) ->
  oTable = $("#charactersTable_#{char_type}").dataTable()
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
          redrawTable(data.character.char_type)
          redrawTable('all')
          $("#notice").empty().append("Character was successfully updated.")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()