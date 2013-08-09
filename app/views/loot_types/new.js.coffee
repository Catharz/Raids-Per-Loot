insertLootType = (loot_type) ->
  oTable = $('#dataTable').dataTable()
  aRow = oTable.fnAddData([
    loot_type.name,
    loot_type.default_loot_method_name,
    "<a href='/loot_types/#{loot_type.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/loot_types/#{loot_type.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/loot_types/#{loot_type.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'loot_type_' + loot_type.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 300
  height: 240
  modal: true
  resizable: false
  title: 'New Loot Type'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/loot_types.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertLootType(data.loot_type)
          displayFlash('notice', 'Loot type was successfully created.')
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
