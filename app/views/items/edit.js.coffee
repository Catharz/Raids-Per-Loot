updateItemTableColumns = (item, oTable, aPos) ->
  oTable.fnUpdate(item.loot_type_name, aPos, 2)
  oTable.fnUpdate(item.loot_type_name, aPos, 3)
  oTable.fnUpdate(item.class_names, aPos, 5)

refreshDropDetails = (drop_id, oTable, aPos) ->
  $.get "/drops/#{drop_id}.json", (data, text, xhr) ->
    if (xhr.status = 200)
      if (data.drop.invalid_reason == null)
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

$("#edit-invalid-item-form").dialog
  autoOpen: true
  height: 550
  width: 420
  modal: true
  title: 'Edit Item'
  buttons:
    "Cancel": =>
      $("#edit-invalid-item-form").dialog "close"
    "Save": ->
      $.post "/items/<%= @item.id %>.json", $("#edit-invalid-item-form form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          updateInvalidDropItem(data.item)
          $("#notice").empty().append("Item updated successfully")
          $("#edit-invalid-item-form").dialog "close"
  open: ->
    $("#edit-invalid-item-form").html "<%= escape_javascript(render('dialog_form')) %>"