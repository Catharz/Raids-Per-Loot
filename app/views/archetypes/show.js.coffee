$("#popup").dialog
  autoOpen: true
  width: 350
  modal: true
  resizable: false
  title: 'Show Archetype'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()