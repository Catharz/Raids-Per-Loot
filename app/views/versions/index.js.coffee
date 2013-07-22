$("#popup").dialog
  autoOpen: true
  width: 1200
  height: 600
  modal: true
  resizable: false
  title: 'Show History'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('history')) %>"
    $('#historyTable').dataTable
      "bJQueryUI": true
      "sPaginationType": "full_numbers"
      "aaSorting": [[2,'desc']]