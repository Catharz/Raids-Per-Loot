$("#popup").dialog
  autoOpen: true
  width: 450
  modal: true
  resizable: false
  title: 'Show Adjustment'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()