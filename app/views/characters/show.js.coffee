$("#popup").dialog
  autoOpen: true
  height: 700
  width: 1100
  modal: true
  resizable: true
  title: '<%= @character.name %>'
  buttons:
    "Close": ->
      $("#popup").html ""
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript( render('details') ) %>"
    $("#popup #tabBook").tabs()
    $("#subTabBook").tabs()
