jQuery.extend jQuery.fn.dataTableExt.oSort,
  "date-time-pre": (a) ->
    unless $.trim(a) is ""
      frDatea = $.trim(a).split(" ")
      frTimea = frDatea[1].split(":")
      frDatea2 = frDatea[0].split("-")
      x = (frDatea2[0] + frDatea2[1] + frDatea2[2] + frTimea[0] + frTimea[1] + frTimea[2])
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
    "sPaginationType": "full_numbers"

  # Default DataTable, reverse sorted by first column
  $('#dataTable_desc').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"
    "aaSorting": [[0,'desc']]

  $('#characterTypesTable').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"
    "aoColumns": [
      null, # Player Name
      null, # Character Name
      {"sType": "date"},    # Date Effective
      {"sType": "date"},    # First Raid
      {"sType": "date"},    # Last Raid
      null,                 # Character Type
      {"sType": "numeric", "sClass": "numeric" }, # Normal Wait
      {"sType": "numeric", "sClass": "numeric" }, # Progression Wait
      null,                 # Show
      null,                 # Edit
      null                  # Destroy
    ]
    "aaSorting": [[2,'desc']]

  $('#adjustmentsTable').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"
    "aoColumns": [
      null, # Relationsip
      null, # Adjusted Name
      {"sType": "date"}, # Adjustment Date
      null, # Adjustment Type
      {"sType": "numeric", "sClass": "numeric"}, # Amount
      null, # Reason
      null, # Show
      null, # Edit
      null  # Destroy
    ]
    "aaSorting": [[1,'asc'], [2, 'desc']]

  $('#charactersTable_m').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Main
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "date", "sClass": "nowrap"},    # First Raid
      {"sType": "date", "sClass": "nowrap"},    # Last Raid
      {"sType": "numeric", "sClass": "numeric lootRateTrigger"}, # Armour Rate
      {"sType": "numeric", "sClass": "numeric lootRateTrigger"}, # Jewellery Rate
      {"sType": "numeric", "sClass": "numeric lootRateTrigger"}, # Weapon Rate
      null,                 # Edit Link
      null,                 # Update Link
      null                  # Destroy Link
    ]
    "aaSorting": [[0,'asc']]

  $('#charactersTable_r').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Main
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "date", "sClass": "nowrap"},    # First Raid
      {"sType": "date", "sClass": "nowrap"},    # Last Raid
      {"sType": "numeric", "sClass": "numeric lootRateTrigger"}, # Armour Rate
      {"sType": "numeric", "sClass": "numeric lootRateTrigger"}, # Jewellery Rate
      {"sType": "numeric", "sClass": "numeric lootRateTrigger"}, # Weapon Rate
      null,                 # Edit Link
      null,                 # Update Link
      null                  # Destroy Link
    ]
    "aaSorting": [[0,'asc']]

  $('#charactersTable_g').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Main
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "date", "sClass": "nowrap"},    # First Raid
      {"sType": "date", "sClass": "nowrap"},    # Last Raid
      {"sType": "numeric", "sClass": "numeric lootRateTrigger"}, # Armour Rate
      {"sType": "numeric", "sClass": "numeric lootRateTrigger"}, # Jewellery Rate
      {"sType": "numeric", "sClass": "numeric lootRateTrigger"}, # Weapon Rate
      null,                 # Edit Link
      null,                 # Update Link
      null                  # Destroy Link
    ]
    "aaSorting": [[0,'asc']]

  $('#charactersTable_all').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Main
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "date", "sClass": "nowrap"},    # First Raid
      {"sType": "date", "sClass": "nowrap"},    # Last Raid
      {"sType": "numeric", "sClass": "numeric"}, # Armour Rate
      {"sType": "numeric", "sClass": "numeric"}, # Jewellery Rate
      {"sType": "numeric", "sClass": "numeric"}, # Weapon Rate
      null,                 # Edit Link
      null,                 # Update Link
      null                  # Destroy Link
    ]
    "aaSorting": [[0,'asc']]

  $('#characterStatsTable_m').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "numeric", "sClass": "numeric" }, # Level
      {"sType": "numeric", "sClass": "numeric" }, # AAs
      {"sType": "numeric", "sClass": "numeric" }, # Health
      {"sType": "numeric", "sClass": "numeric" }, # Power
      {"sType": "numeric", "sClass": "numeric" }, # Crit
      {"sType": "numeric", "sClass": "numeric adornmentsTrigger" }, # Adornments
      {"sType": "numeric", "sClass": "numeric" }, # Crit Bonus
      {"sType": "numeric", "sClass": "numeric" }  # Potency
    ]
    "aaSorting": [[0,'asc']]

  $('#characterStatsTable_r').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "numeric", "sClass": "numeric" }, # Level
      {"sType": "numeric", "sClass": "numeric" }, # AAs
      {"sType": "numeric", "sClass": "numeric" }, # Health
      {"sType": "numeric", "sClass": "numeric" }, # Power
      {"sType": "numeric", "sClass": "numeric" }, # Crit
      {"sType": "numeric", "sClass": "numeric adornmentsTrigger" }, # Adornments
      {"sType": "numeric", "sClass": "numeric" }, # Crit Bonus
      {"sType": "numeric", "sClass": "numeric" }  # Potency
    ]
    "aaSorting": [[0,'asc']]

  $('#characterStatsTable_g').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "numeric", "sClass": "numeric" }, # Level
      {"sType": "numeric", "sClass": "numeric" }, # AAs
      {"sType": "numeric", "sClass": "numeric" }, # Health
      {"sType": "numeric", "sClass": "numeric" }, # Power
      {"sType": "numeric", "sClass": "numeric" }, # Crit
      {"sType": "numeric", "sClass": "numeric adornmentsTrigger" }, # Adornments
      {"sType": "numeric", "sClass": "numeric" }, # Crit Bonus
      {"sType": "numeric", "sClass": "numeric" }  # Potency
    ]
    "aaSorting": [[0,'asc']]

  $('#characterStatsTable_all').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Class
      {"bSearchable": true, "bVisible": false},  # Base Class
      {"sType": "numeric", "sClass": "numeric" }, # Level
      {"sType": "numeric", "sClass": "numeric" }, # AAs
      {"sType": "numeric", "sClass": "numeric" }, # Health
      {"sType": "numeric", "sClass": "numeric" }, # Power
      {"sType": "numeric", "sClass": "numeric" }, # Crit
      {"sType": "numeric", "sClass": "numeric adornmentsTrigger" }, # Adornments
      {"sType": "numeric", "sClass": "numeric" }, # Crit Bonus
      {"sType": "numeric", "sClass": "numeric" }  # Potency
    ]
    "aaSorting": [[0,'asc']]

  $('#difficultiesTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      {"sType": "numeric"}, # Rating
      {"sType": "numeric"}, # Zones
      {"sType": "numeric"}, # Mobs
      null, # Show
      null, # Edit
      null  # Destroy
    ]
    "aaSorting": [[1,'asc']]

  $('#dropsTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "bProcessing": true
    "bServerSide": true
    "aaSorting": [[5,'desc']]
    "sAjaxSource": $('#dropsTable').data('source')
    "fnDrawCallback": ( oSettings ) ->
      $(".table-button").button()

  $('#invalidDropsTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
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
      null  # Edit Item
    ]
    "aaSorting": [[7,'desc']]

  $('#instancesTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Zone Name
      { "sType": "date-time" },    # Raid Date
      { "sType": "numeric", "sClass": "numeric" }, # players
      { "sType": "numeric", "sClass": "numeric" }, # characters
      { "sType": "numeric", "sClass": "numeric" }, # kills
      { "sType": "numeric", "sClass": "numeric" }, # drops
      null,                   # Show Link
      null,                   # Edit Link
      null                    # Destroy Link
    ]
    "aaSorting": [[1,'desc']]

  $('#itemsTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType": "full_numbers"
    "bProcessing": true
    "bServerSide": true
    "aaSorting": [[0,'asc']]
    "sAjaxSource": $('#itemsTable').data('source')
    "fnDrawCallback": ( oSettings ) ->
      $(".table-button").button()

  $('#mobsTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Alias
      null, # Zone Name
      null, # Difficulty
      { "sType": "numeric", "sClass": "numeric" }, # kills
      { "sType": "date-time" },    # First Killed
      { "sType": "date-time" },    # Last Killed
      null, # Progression
      null,                   # Show Link
      null,                   # Edit Link
      null                    # Destroy Link
    ]

  $('#playersAttendanceTable').dataTable
    "bJQueryUI": true,
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers",
    "aoColumns": [
      null,                   # Name
      { "sType": "date" },    # First Raid
      { "sType": "date" },    # Last Raid
      { "sType": "numeric", "sClass": "numeric" }, # No. Raids
      { "sType": "numeric", "sClass": "numeric" }, # Total Attendance
      { "sType": "numeric", "sClass": "numeric" }, # 1 Year Attendance
      { "sType": "numeric", "sClass": "numeric" }, # 9 Months Attendance
      { "sType": "numeric", "sClass": "numeric" }, # 6 Months Attendance
      { "sType": "numeric", "sClass": "numeric" }, # 3 Months Attendance
      { "sType": "numeric", "sClass": "numeric" } # 1 Month Attendance
    ]
    "aaSorting": [[0,'asc']]

  $('#playersTable').dataTable
    "bJQueryUI": true,
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers",
    "aoColumns": [
      null,                   # Name
      null,                   # Rank
      { "sType": "date" },    # First Raid
      { "sType": "date" },    # Last Raid
      { "sType": "numeric", "sClass": "lootRateTrigger numeric" }, # Armour Rate
      { "sType": "numeric", "sClass": "lootRateTrigger numeric" }, # Jewellery Rate
      { "sType": "numeric", "sClass": "lootRateTrigger numeric" }, # Weapon Rate
      null,                   # Show Link
      null,                   # Edit Link
      null                    # Destroy Link
    ]
    "aaSorting": [[0,'asc']]

  $('#raidsTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      { "sType": "date" },    # Raid Date
      null,                  # Raid Type
      { "sType": "numeric", "sClass": "numeric" }, # instances
      { "sType": "numeric", "sClass": "numeric" }, # players
      { "sType": "numeric", "sClass": "numeric" }, # characters
      { "sType": "numeric", "sClass": "numeric" }, # kills
      { "sType": "numeric", "sClass": "numeric" }, # drops
      null,                   # Show Link
      null,                   # Edit Link
      null                    # Destroy Link
    ]
    "aaSorting": [[0,'desc']]

  $('#raidTypesTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Name
      null, # Raid Counted
      {"sType": "numeric", "sClass": "numeric"}, # Raid Points
      null, # Loot Counted
      {"sType": "numeric", "sClass": "numeric"}, # Loot Cost
      null, # Show
      null, # Edit
      null  # Destroy
    ]

  $('#ranksTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aaSorting": [[1,'asc']]

  $('#zonesTable').dataTable
    "bJQueryUI": true
    "sPaginationType":"full_numbers"
    "aoColumns": [
      null, # Zone Name
      null, # Mobs
      null, # Difficulty
      { "sType": "numeric", "sClass": "numeric" }, # times run
      { "sType": "date" },    # First Run
      { "sType": "date" },    # Last Run
      null, # Progression
      null,                   # Show Link
      null,                   # Edit Link
      null                    # Destroy Link
    ]

  # DataTables for Tabs on other pages

  $('#charactersTabTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "aoColumns": [
      { "sClass": "characterPopupTrigger" }, #  Name
      null,                   #  Main
      null,                   #  Rank
      null,                   #  Class
      null,                   #  Base Class
      { "sType": "date" },    #  First Raid
      { "sType": "date" },    #  Last Raid
      { "sType": "numeric", "sClass": "numeric" }, #  No. Raids
      { "sType": "numeric", "sClass": "numeric" }, #  No. Instances
      { "sType": "numeric", "sClass": "numeric" }, #  Armour Rate
      { "sType": "numeric", "sClass": "numeric" }, #  Jewellery Rate
      { "sType": "numeric", "sClass": "numeric" }  #  Weapon Rate
    ]

  $('#dropsTabTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
    "sPaginationType":"full_numbers"
    "aaSorting": [[3,'desc']]

  $('#instancesTabTable').dataTable
    "bJQueryUI": true
    "sPaginationType": "full_numbers"
    "aaSorting": [[2,'desc']]

  $('#itemsTabTable').dataTable
    "bJQueryUI": true
    "bStateSave": true
    "iCookieDuration": 600
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
    "iCookieDuration": 600
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