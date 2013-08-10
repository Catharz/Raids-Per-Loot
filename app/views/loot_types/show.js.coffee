$("#popup").dialog
  autoOpen: true
  width: 300
  height: 200
  modal: true
  resizable: false
  title: 'Show Loot type'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()
