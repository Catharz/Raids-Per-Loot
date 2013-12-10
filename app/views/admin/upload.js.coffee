$("#popup").dialog
  autoOpen: true
  width: 500
  height: 440
  modal: true
  resizable: false
  title: 'Upload Files'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('upload')) %>"
    $(".actions").empty()