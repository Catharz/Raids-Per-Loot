jQuery.extend jQuery.fn.dataTableExt.oSort,
  "date-time-pre": (a) ->
    unless $.trim(a) is ""
      frDatea = $.trim(a).split(" ")
      frTimea = frDatea[1].split(":")
      frDatea2 = frDatea[0].split("-")
      x = (frDatea2[0] + frDatea2[1] + frDatea2[2] + frTimea[0] + frTimea[1] + frTimea[2]) * 1
    else
      x = 10000000000000 # = l'an 1000 ...
    x

  "date-time-asc": (a, b) ->
    a - b

  "date-time-desc": (a, b) ->
    b - a

jQuery ->
  # Default DataTable

  $('#dataTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType": "full_numbers"

  $('#characterTypesTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType": "full_numbers"
    "aoColumns": [
      null, # Player Name
      null, # Character Name
      {"sType": "date"},    # Date Effective
      {"sType": "date"},    # First Raid
      {"sType": "date"},    # Last Raid
      null,                 # Character Type
      {"sType": "numeric"}, # Normal Wait
      {"sType": "numeric"}, # Progression Wait
      null,                 # Edit
      null                  # Destroy
    ]
    "aaSorting": [[2,'desc']]

  $('#adjustmentsTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType": "full_numbers"
    "aaSorting": [[1,'asc'], [2, 'desc']]

  $('#characterAdjustmentsTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType": "full_numbers"
    "aaSorting": [[0,'desc']]

  $('#playerAdjustmentsTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType": "full_numbers"
    "aaSorting": [[0,'desc']]

  $('#charactersTable_m').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Main
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

  $('#charactersTable_r').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Main
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

  $('#charactersTable_g').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Main
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

  $('#characterStatsTable_m').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "numeric"}, # Level
      {"sType": "numeric"}, # AAs
      {"sType": "numeric"}, # Health
      {"sType": "numeric"}, # Power
      {"sType": "numeric"}, # Crit
      {"sType": "numeric"}, # Crit Bonus
      {"sType": "numeric"}, # Potency
      {"sType": "numeric"}, # Adornments
      null,                 # White Adornments
      null,                 # Yellow Adornments
      null                  # Red Adornments
    ]
    "aaSorting": [[0,'asc']]

  $('#characterStatsTable_r').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "numeric"}, # Level
      {"sType": "numeric"}, # AAs
      {"sType": "numeric"}, # Health
      {"sType": "numeric"}, # Power
      {"sType": "numeric"}, # Crit
      {"sType": "numeric"}, # Crit Bonus
      {"sType": "numeric"}, # Potency
      {"sType": "numeric"}, # Adornments
      null,                 # White Adornments
      null,                 # Yellow Adornments
      null                  # Red Adornments
    ]
    "aaSorting": [[0,'asc']]

  $('#characterStatsTable_g').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "numeric"}, # Level
      {"sType": "numeric"}, # AAs
      {"sType": "numeric"}, # Health
      {"sType": "numeric"}, # Power
      {"sType": "numeric"}, # Crit
      {"sType": "numeric"}, # Crit Bonus
      {"sType": "numeric"}, # Potency
      {"sType": "numeric"}, # Adornments
      null,                 # White Adornments
      null,                 # Yellow Adornments
      null                  # Red Adornments
    ]
    "aaSorting": [[0,'asc']]

  $('#characterStatsTable_all').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "numeric"}, # Level
      {"sType": "numeric"}, # AAs
      {"sType": "numeric"}, # Health
      {"sType": "numeric"}, # Power
      {"sType": "numeric"}, # Crit
      {"sType": "numeric"}, # Crit Bonus
      {"sType": "numeric"}, # Potency
      {"sType": "numeric"}, # Adornments
      null,                 # White Adornments
      null,                 # Yellow Adornments
      null                  # Red Adornments
    ]
    "aaSorting": [[0,'asc']]

  $('#dropsTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "bProcessing": true
    "bServerSide": true
    "aaSorting": [[5,'desc']]
    "sAjaxSource": $('#dropsTable').data('source')

  $('#invalidDropsTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Character Name
      null, # Character Class
      null, # Drop Type
      null, # Item Type
      null, # Item Name
      null, # Item Classes
      null, # Loot Method
      {"sType": "date-time"}, # Drop Time
      null, # Invalid Reason
      null, # Edit Drop
      null, # Edit Item
    ]
    "aaSorting": [[7,'desc']]

  $('#instancesTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aaSorting": [[1,'desc']]

  $('#itemsTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType": "full_numbers"
    "bProcessing": true
    "bServerSide": true
    "aaSorting": [[0,'asc']]
    "sAjaxSource": $('#itemsTable').data('source')

  $('#playersAttendanceTable').dataTable
    "bJQueryUI": true,
    "bStateSave": true
    "sPaginationType":"full_numbers",
    "aoColumns": [
      null,                   # Name
      { "sType": "date" },    # First Raid
      { "sType": "date" },    # Last Raid
      { "sType": "numeric" }, # No. Raids
      { "sType": "numeric" }, # Total Attendance
      { "sType": "numeric" }, # 1 Year Attendance
      { "sType": "numeric" }, # 9 Months Attendance
      { "sType": "numeric" }, # 6 Months Attendance
      { "sType": "numeric" }, # 3 Months Attendance
      { "sType": "numeric" } # 1 Month Attendance
    ]
    "aaSorting": [[0,'asc']]

  $('#playersTable').dataTable
    "bJQueryUI": true,
    "bStateSave": true
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

  $('#raidsTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aaSorting": [[0,'desc']]

  $('#ranksTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aaSorting": [[1,'asc']]

  # DataTables for Tabs on other pages

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
    "bStateSave": true
    "sPaginationType":"full_numbers"
    "aaSorting": [[3,'desc']]

  $('#instancesTabTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "sPaginationType": "full_numbers"
    "aaSorting": [[2,'desc']]

  $('#itemsTabTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
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
    "bStateSave": true
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