updateDifficulty = (difficulty) ->
  oTable = $('#dataTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("difficulty_#{difficulty.id}") )
  oTable.fnUpdate(difficulty.name, aPos, 0)
  oTable.fnUpdate(difficulty.rating, aPos, 1)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 350
  modal: true
  resizable: false
  title: 'Edit Difficulty'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/difficulties/<%= @difficulty.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        updateDifficulty(data.difficulty)
        displayFlash('notice', 'Difficulty was successfully updated.')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()