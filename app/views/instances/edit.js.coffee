updateInstance = (instance) ->
  oTable = $('#instancesTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("instance_#{instance.id}") )
  oTable.fnUpdate(instance.zone_name, aPos, 0)
  oTable.fnUpdate(instance.start_time, aPos, 1)
  oTable.fnUpdate(instance.players.length, aPos, 2)
  oTable.fnUpdate(instance.characters.length, aPos, 3)
  oTable.fnUpdate(instance.kills.length, aPos, 4)
  oTable.fnUpdate(instance.kills.length, aPos, 5)
  oTable.fnUpdate(instance.drops.length, aPos, 6)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 1100
  height: 600
  modal: true
  resizable: false
  title: 'Edit Instance'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/instances/<%= @instance.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          updateInstance(data.instance)
          $("#notice").empty().append("Instance was successfully updated.")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
    $(".table-button").button()
    $(".button").button()
    $("#tabBook").tabs()