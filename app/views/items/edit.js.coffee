updateItemTableColumns = (item, oTable, aPos) ->
  oTable.fnUpdate(item.loot_type_name, aPos, 2)
  oTable.fnUpdate(item.loot_type_name, aPos, 3)
  oTable.fnUpdate(item.class_names, aPos, 5)

refreshDropDetails = (drop_id, oTable, aPos) ->
  $.get "/drops/#{drop_id}.json", (data, text, xhr) ->
    if (xhr.status = 200)
      if (data.drop.invalid_reason == "")
        oTable.fnDeleteRow( aPos )
      else
        oTable.fnUpdate(data.drop.invalid_reason, aPos, 8)

updateInvalidDropItem = (item) ->
  oTable = $('#invalidDropsTable').dataTable()
  $.get "/items/<%= @item.id %>.json", (data, text, xhr) ->
    if (xhr.status == 200)
      oTable.$(".item_#{data.item.id}").each ->
        aPos = oTable.fnGetPosition( this )
        updateItemTableColumns(data.item, oTable, aPos)
        refreshDropDetails(this.dataset['drop_id'], oTable, aPos)
      oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  height: 520
  modal: true
  resizable: false
  title: 'Edit Item'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/items/<%= @item.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          updateInvalidDropItem(data.item)
          $("#notice").empty().append("Item updated successfully")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('dialog_form')) %>"