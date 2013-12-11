$ ->
  formatFileSize = (bytes) ->
    return ""  if typeof bytes isnt "number"
    return (bytes / 1000000000).toFixed(2) + " GB"  if bytes >= 1000000000
    return (bytes / 1000000).toFixed(2) + " MB"  if bytes >= 1000000
    (bytes / 1000).toFixed(2) + " KB"

  ul = $("#upload ul")
  $("#drop a").click ->
    $(this).parent().find("input").click()

  $("#upload").fileupload
    dropZone: $("#drop")
    add: (e, data) ->
      tpl = $("<li class=\"working\"><input type=\"text\" value=\"0\" data-width=\"48\" data-height=\"48\"" + " data-fgColor=\"#0788a5\" data-readOnly=\"1\" data-bgColor=\"#3e4043\" /><p></p><span></span></li>")
      tpl.find("p").text(data.files[0].name).append "<i>" + formatFileSize(data.files[0].size) + "</i>"
      data.context = tpl.appendTo(ul)
      tpl.find("input").knob()
      tpl.find("span").click ->
        jqXHR.abort() if tpl.hasClass("working") or tpl.hasClass("complete")
        tpl.fadeOut ->
          tpl.remove()

      jqXHR = data.submit()

    progress: (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      data.context.find("input").val(progress).change()
      if progress is 100
        data.context.removeClass "working"
        data.context.addClass "complete"

    fail: (e, data) ->
      data.context.addClass "error"

  $(document).on "drop dragover", (e) ->
    e.preventDefault()