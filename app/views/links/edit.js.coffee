updateLink = (link) ->
  oTable = $('#dataTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("link_#{link.id}") )
  oTable.fnUpdate(link.url, aPos, 0)
  oTable.fnUpdate(link.title, aPos, 1)
  oTable.fnUpdate(link.description, aPos, 2)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 460
  height: 500
  modal: true
  resizable: false
  title: 'Edit Link'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/links/<%= @link.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        updateLink(data.link)
        displayFlash('notice', 'Link was successfully updated.')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
