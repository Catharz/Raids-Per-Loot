$("#popup").dialog
  autoOpen: true
  width: 1260
  height: 600
  modal: true
  resizable: true
  title: 'Show Instance'
  buttons:
    "Close": ->
      $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('details')) %>"
    $('#dataTable').dataTable
      "bJQueryUI": true
      "sPaginationType": "full_numbers"
    $('#playersTabTable').dataTable
      "bJQueryUI": true
      "bStateSave": true
      "sPaginationType":"full_numbers"
      "aoColumns": [
        null,                   #  Name
        null,                   #  Rank
      { "sType": "date" },    #  First Instance
      { "sType": "date" },    #  Last Instance
      { "sType": "numeric" }, #  No. Instances
      { "sType": "numeric" }, #  No. Instances
      { "sType": "numeric" }, #  Armour Rate
      { "sType": "numeric" }, #  Jewellery Rate
      { "sType": "numeric" }  #  Weapon Rate
      ]
      "aaSorting": [[0,'asc']]
    $('#charactersTabTable').dataTable
      "bJQueryUI": true
      "bStateSave": true
      "sPaginationType":"full_numbers"
      "aoColumns": [
        null,                   #  Name
        null,                   #  Main
        null,                   #  Rank
        null,                   #  Class
        null,                   #  Base Class
      { "sType": "date" },    #  First Instance
      { "sType": "date" },    #  Last Instance
      { "sType": "numeric" }, #  No. Instances
      { "sType": "numeric" }, #  No. Instances
      { "sType": "numeric" }, #  Armour Rate
      { "sType": "numeric" }, #  Jewellery Rate
      { "sType": "numeric" }  #  Weapon Rate
      ]
    $('#dropsTabTable').dataTable
      "bJQueryUI": true
      "bStateSave": true
      "iCookieDuration": 600
      "sPaginationType":"full_numbers"
      "aaSorting": [[3,'desc']]
    $(".actions").empty()
    $("#tabBook").tabs()