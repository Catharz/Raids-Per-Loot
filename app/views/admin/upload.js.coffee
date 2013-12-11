$("#popup").dialog
  autoOpen: true
  width: 550
  height: 440
  modal: true
  resizable: false
  title: 'Upload Files'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
      # Hack: redirecting back to admin because the uploads don't work nicely on subsequent popup loads
      window.location.href = '/admin'
  open: ->
    $("#popup").html "<%= escape_javascript(render('upload')) %>"
    $(".actions").empty()