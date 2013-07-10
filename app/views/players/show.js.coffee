$("#popup").dialog
  autoOpen: true
  width: 1200
  height: 600
  modal: true
  resizable: false
  title: 'Show Player'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $('#charactersTabTable').dataTable
      "bJQueryUI": true
      "sPaginationType":"full_numbers"
    $('#dropsTabTable').dataTable
      "bJQueryUI": true
      "sPaginationType":"full_numbers"
      "aaSorting": [[3,'desc']]
    $('#instancesTabTable').dataTable
      "bJQueryUI": true
      "sPaginationType": "full_numbers"
      "aaSorting": [[2,'desc']]
    $('#dataTable_desc').dataTable
      "bJQueryUI": true
      "sPaginationType": "full_numbers"
      "aaSorting": [[0,'desc']]
    $("#popup #tabBook").tabs()
    $(".actions").empty()