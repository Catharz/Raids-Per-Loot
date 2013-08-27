insertLinkCategory = (link_category) ->
  oTable = $('#dataTable').dataTable()
  aRow = oTable.fnAddData([
    link_category.title,
    link_category.description,
    "<a href='/link_categories/#{link_category.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/link_categories/#{link_category.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/link_categories/#{link_category.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'link_category_' + link_category.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  width: 460
  height: 340
  modal: true
  resizable: false
  title: 'New Link Category'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/link_categories.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        insertLinkCategory(data.link_category)
        displayFlash('notice', 'Link Category was successfully created.')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()