$("#popup").dialog
  autoOpen: true
  width: 350
  modal: true
  resizable: false
  title: 'Show Class'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()