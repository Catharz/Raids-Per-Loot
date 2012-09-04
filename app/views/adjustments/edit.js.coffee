updateAdjustment = (adjustment) ->
  oTable = $('#adjustmentsTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("adjustment_#{adjustment.id}") )
  $.get "/adjustments/#{adjustment.id}.json", (data, text, xhr) ->
    if (xhr.status == 200)
      oTable.fnUpdate(data.adjustment.adjustable_type, aPos, 0)
      oTable.fnUpdate(data.adjustment.adjusted_name, aPos, 1)
      oTable.fnUpdate(data.adjustment.adjustment_date, aPos, 2)
      oTable.fnUpdate(data.adjustment.adjustment_type, aPos, 3)
      oTable.fnUpdate(data.adjustment.amount, aPos, 4)
      oTable.fnUpdate(data.adjustment.reason, aPos, 5)
      oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 450
  modal: true
  resizable: false
  title: 'Edit Adjustment'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/adjustments/<%= @adjustment.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 200)
          updateAdjustment(data.adjustment)
          $("#notice").empty().append("Adjustment was successfully updated.")
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
    $("#datepicker").datepicker
      dateFormat: 'yy-mm-dd'
    $("select#adjustment_adjustable_type").change ->
      adjustable_type = $(this).val()
      adjustable_select = $(this).next 'select'
      options_url = ""

      if adjustable_type == "Player"
        options_url = "/players/option_list"
      else
        options_url = "/characters/option_list"

      $("#adjustable_field").empty()
      $("#adjustable_field").append "<strong>" + adjustable_type + ":</strong> "
      $adjustables = $('<select id="adjustment_adjustable_id" name="adjustment[adjustable_id]"></select>').appendTo '#adjustable_field'
      $adjustables.load options_url
