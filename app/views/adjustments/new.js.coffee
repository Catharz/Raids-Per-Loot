insertAdjustment = (adjustment) ->
  oTable = $('#adjustmentsTable').dataTable()
  $.get "/adjustments/#{adjustment.id}.json", (data, text, xhr) ->
    if (xhr.status == 200)
      oTable.fnAddData([
        data.adjustment.adjustable_type,
        data.adjustment.adjusted_name,
        data.adjustment.adjustment_date,
        data.adjustment.adjustment_type,
        data.adjustment.amount,
        data.adjustment.reason,
        "<a href='/adjustments/#{adjustment.id}' data-remote='true' class='table-button'>Show</a>",
        "<a href='/adjustments/#{adjustment.id}/edit' data-remote='true' class='table-button'>Edit</a>",
        "<a href='/adjustments/#{adjustment.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' class='table-button'>Destroy</a>"
      ])
      $(".table-button").button()
      oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  height: 450
  width: 450
  modal: true
  resizable: false
  title: 'New Adjustment'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/adjustments.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertAdjustment(data.adjustment)
          $("#notice").empty().append("Adjustment was successfully created.")
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
