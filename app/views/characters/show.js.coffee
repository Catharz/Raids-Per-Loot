$("#character-show-form").dialog
  autoOpen: true
  height: 800
  width: 1200
  modal: true
  resizable: true
  title: '<%= @character.name %>'
  buttons:
    "Close": ->
      $("#character-show-form").html ""
      $("#character-show-form").dialog "close"
  open: ->
    $("#character-show-form").html "<%= escape_javascript( render('details') ) %>"
    $('#characterTypesTable').dataTable
      "bJQueryUI": true
      "bStateSave": true
      "sPaginationType": "full_numbers"
      "sType": "date"
      "aaSorting": [[1,'desc']]
    $('#dropsTabTable').dataTable
      "bJQueryUI": true
      "bStateSave": true
      "sPaginationType":"full_numbers"
      "aaSorting": [[3,'desc']]
    $('#instancesTabTable').dataTable
      "bJQueryUI": true
      "bStateSave": true
      "sPaginationType": "full_numbers"
      "aaSorting": [[2,'desc']]
    $('#characterAdjustmentsTable').dataTable
      "bJQueryUI": true
      "bStateSave": true
      "sPaginationType": "full_numbers"
      "aaSorting": [[0,'desc']]
    $("#subTabBook").tabs()
    $("#character-show-form #tabBook").tabs()
