updateLinkCategory = (link_category) ->
  oTable = $('#dataTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("link_category_#{link_category.id}") )
  oTable.fnUpdate(link_category.title, aPos, 0)
  oTable.fnUpdate(link_category.description, aPos, 1)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 460
  height: 320
  modal: true
  resizable: false
  title: 'Edit Link Category'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/link_categories/<%= @link_category.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          updateLinkCategory(data.link_category)
          $("#notice").empty().append("Link category was successfully updated.")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
