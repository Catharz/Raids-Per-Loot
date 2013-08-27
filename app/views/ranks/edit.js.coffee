updateRank = (rank) ->
  oTable = $('#ranksTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("rank_#{rank.id}") )
  oTable.fnUpdate(rank.name, aPos, 0)
  oTable.fnUpdate(rank.priority, aPos, 1)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 340
  height: 200
  modal: true
  resizable: false
  title: 'Edit Rank'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/ranks/<%= @rank.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        updateRank(data.rank)
        displayFlash('notice', 'Rank was successfully updated.')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()