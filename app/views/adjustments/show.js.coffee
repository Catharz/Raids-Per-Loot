$("#popup").dialog
  autoOpen: true
  height: 430
  width: 605
  modal: true
  resizable: false
  title: 'Show Adjustment'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()