insertDifficulty = (difficulty) ->
  oTable = $('#dataTable').dataTable()
  aRow = oTable.fnAddData([
    difficulty.name,
    difficulty.rating,
    "0",
    "0",
    "<a href='/difficulties/#{difficulty.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/difficulties/#{difficulty.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/difficulties/#{difficulty.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'difficulty_' + difficulty.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 350
  modal: true
  resizable: false
  title: 'New Difficulty'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/difficulties.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertDifficulty(data.difficulty)
          displayFlash('notice', 'Difficulty was successfully created.')
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()