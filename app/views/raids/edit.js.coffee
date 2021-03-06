updateRaid = (raid) ->
  oTable = $('#raidsTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("raid_#{raid.id}") )
  oTable.fnUpdate(raid.raid_date, aPos, 0)
  oTable.fnUpdate(raid.raid_type_name, aPos, 1)
  oTable.fnUpdate(raid.instances.length, aPos, 2)
  oTable.fnUpdate(raid.players.length, aPos, 3)
  oTable.fnUpdate(raid.characters.length, aPos, 4)
  oTable.fnUpdate(raid.kills.length, aPos, 5)
  oTable.fnUpdate(raid.drops.length, aPos, 6)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 1100
  height: 600
  modal: true
  resizable: false
  title: 'Edit Raid'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/raids/<%= @raid.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        updateRaid(data.raid)
        displayFlash 'notice', 'Raid was successfully updated.'
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $("#datepicker").datepicker
      dateFormat: 'yy-mm-dd'
    $(".actions").empty()
    $(".table-button").button()
    $(".button").button()
    $("#tabBook").tabs()
