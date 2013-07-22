insertLink = (link) ->
  oTable = $('#dataTable').dataTable()
  aRow = oTable.fnAddData([
    link.url,
    link.title,
    link.description,
    "<a href='/links/#{link.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/links/#{link.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/links/#{link.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'link_' + link.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 460
  height: 500
  modal: true
  resizable: false
  title: 'New Link'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/links.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertLink(data.link)
          displayFlash('notice', 'Link was successfully created.')
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
