$("#popup").dialog
  autoOpen: true
  height: 300
  width: 390
  modal: true
  resizable: false
  title: 'Show Character Type'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()