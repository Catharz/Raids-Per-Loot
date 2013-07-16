$("#popup").dialog
  autoOpen: true
  height: 600
  width: 450
  modal: true
  resizable: false
  title: 'Show Comment'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()