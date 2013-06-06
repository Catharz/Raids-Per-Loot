$("#popup").dialog
  autoOpen: true
  width: 460
  height: 320
  modal: true
  resizable: false
  title: 'Show Link Category'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()
