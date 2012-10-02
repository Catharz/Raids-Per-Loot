updateRaid = (raid) ->
  oTable = $('#raidsTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("raid_#{raid.id}") )
  oTable.fnUpdate(raid.raid_date, aPos, 0)
  oTable.fnUpdate(raid.instances.length, aPos, 1)
  oTable.fnUpdate(raid.players.length, aPos, 2)
  oTable.fnUpdate(raid.characters.length, aPos, 3)
  oTable.fnUpdate(raid.kills.length, aPos, 4)
  oTable.fnUpdate(raid.drops.length, aPos, 5)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 900
  height: 600
  modal: true
  resizable: false
  title: 'Edit Raid'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/raids/<%= @raid.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          updateRaid(data.raid)
          $("#notice").empty().append("Raid was successfully updated.")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $("#datepicker").datepicker
      dateFormat: 'yy-mm-dd'
    $(".actions").empty()
    $(".table-button").button()
    $(".button").button()
    $("#tabBook").tabs()
