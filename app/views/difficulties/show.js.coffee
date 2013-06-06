$("#popup").dialog
  autoOpen: true
  width: 300
  height: 200
  modal: true
  resizable: false
  title: 'Show Difficulty'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()