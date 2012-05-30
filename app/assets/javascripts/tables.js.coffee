jQuery ->
  # Default DataTable

  $('#dataTable').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"

  $('#characterTypesTable').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"
    "sType": "date"
    "aaSorting": [[1,'desc']]

  $('#adjustmentsTable').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"
    "aaSorting": [[1,'asc'], [2, 'desc']]

  $('#characterAdjustmentsTable').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"
    "aaSorting": [[0,'desc']]

  $('#playerAdjustmentsTable').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"
    "aaSorting": [[0,'desc']]

  $('#charactersTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Main
      null, # Rank
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "date"},    # First Raid
      {"sType": "date"},    # Last Raid
      {"sType": "numeric"}, # No. Raids
      {"sType": "numeric"}, # No. Instances
      {"sType": "numeric"}, # Armour Rate
      {"sType": "numeric"}, # Jewellery Rate
      {"sType": "numeric"}, # Weapon Rate
      null,                 # Update Link
      null                  # Destroy Link
    ]
    "aaSorting": [[0,'asc']]

  $('#dropsTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "bProcessing": true
    "bServerSide": true
    "aaSorting": [[5,'desc']]
    "sAjaxSource": $('#dropsTable').data('source')

  $('#instancesTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aaSorting": [[1,'desc']]

  $('#itemsTable').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"
    "bProcessing": true
    "bServerSide": true
    "aaSorting": [[0,'asc']]
    "sAjaxSource": $('#itemsTable').data('source')

  $('#playersTable').dataTable
    "bJQueryUI": true,
    "sPaginationType":"full_numbers",
    "aoColumns": [
      null,                   # Name
      null,                   # Rank
      { "sType": "date" },    # First Raid
      { "sType": "date" },    # Last Raid
      { "sType": "numeric" }, # No. Raids
      { "sType": "numeric" }, # No. Instances
      { "sType": "numeric" }, # Armour Rate
      { "sType": "numeric" }, # Jewellery Rate
      { "sType": "numeric" }, # Weapon Rate
      null                    # Destroy Link
    ]
    "aaSorting": [[0,'asc']]

  $('#ranksTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aaSorting": [[1,'asc']]

  # DataTables for Tabs on other pages

  $('#charactersTabTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null,                   #  Name
      null,                   #  Main
      null,                   #  Rank
      null,                   #  Class
      null,                   #  Base Class
      { "sType": "date" },    #  First Raid
      { "sType": "date" },    #  Last Raid
      { "sType": "numeric" }, #  No. Raids
      { "sType": "numeric" }, #  No. Instances
      { "sType": "numeric" }, #  Armour Rate 
      { "sType": "numeric" }, #  Jewellery Rate 
      { "sType": "numeric" }  #  Weapon Rate
    ]

  $('#dropsTabTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aaSorting": [[3,'desc']]

  $('#instancesTabTable').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"
    "aaSorting": [[2,'desc']]

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

  $('#playersTabTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null,                   #  Name
      null,                   #  Rank
      { "sType": "date" },    #  First Raid
      { "sType": "date" },    #  Last Raid
      { "sType": "numeric" }, #  No. Raids
      { "sType": "numeric" }, #  No. Instances
      { "sType": "numeric" }, #  Armour Rate   
      { "sType": "numeric" }, #  Jewellery Rate   
      { "sType": "numeric" }  #  Weapon Rate   
    ]
    "aaSorting": [[0,'asc']]