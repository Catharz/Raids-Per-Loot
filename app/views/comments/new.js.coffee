insertComment = (comment) ->
  oTable = $('#commentsTable').dataTable()
  aRow = oTable.fnAddData([
    comment.commented_type,
    comment.commented_name,
    comment.comment_date,
    comment.comment,
    "<a href='/comments/#{comment.id}' data-remote='true' class='table-button'>Show</a>",
    "<a href='/comments/#{comment.id}/edit' data-remote='true' class='table-button'>Edit</a>",
    "<a href='/comments/#{comment.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' data-remote='true' class='table-button'>Destroy</a>"
  ])
  aNode = oTable.fnSettings().aoData[aRow[0]].nTr
  aNode.setAttribute('id', 'comment_' + comment.id)
  $(".table-button").button()
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  height: 640
  width: 450
  modal: true
  resizable: false
  title: 'New Comment'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/comments.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        if (xhr.status == 201)
          insertComment(data.comment)
          displayFlash('notice', 'Comment was successfully created.')
          $("#popup").dialog "close"
  open: ->
    $("#popup").html "<%= escape_javascript(render('form')) %>"
    $(".actions").empty()
    $("#datepicker").datepicker
      dateFormat: 'yy-mm-dd'
      $("select#comment_commented_type").change ->
        commented_type = $(this).val()
        commented_select = $(this).next 'select'
        options_url = ""

        if commented_type == "Player"
          options_url = "/players/option_list"
        else
          options_url = "/characters/option_list"

        $("#commented_field").empty()
        $("#commented_field").append "<strong>" + commented_type + ":</strong> "
        $commenteds = $('<select id="comment_commented_id" name="comment[commented_id]"></select>').appendTo '#commented_field'
        $commenteds.load options_url