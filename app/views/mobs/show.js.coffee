$("#popup").dialog
  autoOpen: true
  width: 1200
  height: 590
  modal: true
  resizable: false
  title: 'Show Mob'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $(".actions").empty()
    $("#tabBook").tabs()
    $('#dropsTabTable').dataTable
      "bJQueryUI": true
      "sPaginationType":"full_numbers"
      "aaSorting": [[3,'desc']]
    $('#itemsTabTable').dataTable
      "bJQueryUI": true
      "sPaginationType": "full_numbers"
      "aoColumns": [
        null, #  Name
        null, #  Loot Type
        null, #  Slots
        null  #  Classes
      ]
      "aaSorting": [[0,'asc']]

