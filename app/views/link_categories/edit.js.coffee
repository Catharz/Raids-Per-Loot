updateLinkCategory = (link_category) ->
  oTable = $('#dataTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("link_category_#{link_category.id}") )
  oTable.fnUpdate(link_category.title, aPos, 0)
  oTable.fnUpdate(link_category.description, aPos, 1)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 460
  height: 340
  modal: true
  resizable: false
  title: 'Edit Link Category'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/link_categories/<%= @link_category.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        updateLinkCategory(data.link_category)
        displayFlash('notice', 'Link category was successfully updated.')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
