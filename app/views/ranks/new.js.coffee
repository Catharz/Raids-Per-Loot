insertRank = (rank) ->
  oTable = $('#ranksTable').dataTable()
  aRow = oTable.fnAddData([
    rank.name,
    rank.priority,
    "<a href='/ranks/#{rank.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/ranks/#{rank.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/ranks/#{rank.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  console.log 'row added'
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'rank_' + rank.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 340
  height: 200
  modal: true
  resizable: false
  title: 'New Rank'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/ranks.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertRank(data.rank)
          displayFlash('notice', 'Rank was successfully created.')
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()