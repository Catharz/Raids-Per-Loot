insertAdjustment = (adjustment) ->
  oTable = $('#adjustmentsTable').dataTable()
  aRow = oTable.fnAddData([
    adjustment.adjustable_type,
    adjustment.adjusted_name,
    adjustment.adjustment_date,
    adjustment.adjustment_type,
    adjustment.amount,
    adjustment.reason,
    "<a href='/adjustments/#{adjustment.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/adjustments/#{adjustment.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/adjustments/#{adjustment.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'adjustment_' + adjustment.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  height: 430
  width: 605
  modal: true
  resizable: false
  title: 'New Adjustment'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/adjustments.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        insertAdjustment(data.adjustment)
        displayFlash('notice', 'Adjustment was successfully created.')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
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
