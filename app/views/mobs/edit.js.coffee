yesNo = (value) ->
  if value then "Yes" else "No"

updateMob = (mob) ->
  oTable = $('#mobsTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("mob_#{mob.id}") )
  oTable.fnUpdate(mob.name, aPos, 0)
  oTable.fnUpdate(mob.alias, aPos, 1)
  oTable.fnUpdate(mob.zone_name, aPos, 2)
  oTable.fnUpdate(mob.difficulty_name, aPos, 3)
  oTable.fnUpdate(mob.kills, aPos, 4)
  oTable.fnUpdate(mob.first_killed, aPos, 5)
  oTable.fnUpdate(mob.last_killed, aPos, 6)
  oTable.fnUpdate(yesNo(mob.progression), aPos, 7)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 450
  height: 500
  modal: true
  resizable: false
  title: 'Edit Mob'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/mobs/<%= @mob.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        updateMob(data.mob)
        displayFlash('notice', 'Mob was successfully updated.')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
