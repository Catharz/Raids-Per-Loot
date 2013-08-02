$("#popup").dialog
  autoOpen: true
  width: 320
  height: 200
  modal: true
  resizable: false
  title: 'Show Rank'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()