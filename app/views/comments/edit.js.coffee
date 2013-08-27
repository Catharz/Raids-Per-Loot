updateComment = (comment) ->
  oTable = $('#commentsTable').dataTable()
  aPos = oTable.fnGetPosition( document.getElementById("comment_#{comment.id}") )
  oTable.fnUpdate(comment.commented_type, aPos, 0)
  oTable.fnUpdate(comment.commented_name, aPos, 1)
  oTable.fnUpdate(comment.comment_date, aPos, 2)
  oTable.fnUpdate(comment.comment, aPos, 3)
  oTable.fnDraw()

$("#popup").dialog
  autoOpen: true
  height: 360
  width: 620
  modal: true
  resizable: false
  title: 'Edit Comment'
  buttons:
    "Cancel": ->
      $("#popup").dialog "close"
    "Save": ->
      $.post "/comments/<%= @comment.id %>.json", $("#popup form").serializeArray(), (data, text, xhr) ->
        updateComment(data.comment)
        displayFlash('notice', 'Comment was successfully updated.')
        $("#popup").dialog "close"
      .fail (data, text, xhr) ->
          displayFlash 'error', parseErrors(data.responseJSON)
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
      $("#commented_field").append '<label class="header" for="comment_commented_id">' + commented_type + ':</label><span class="data"></span>'
      $commented_items = $('<select id="comment_commented_id" name="comment[commented_id]"></select>').appendTo '#commented_field span.data'
      $commented_items.load options_url