getAttendanceData = ->
  my_data = null
  $.ajax(
    type: "GET"
    url: "/characters/attendance.json"
    beforeSend: ->
      $("#attendance_data").append "<p class=\"loading-text\">Loading attendance details...</p>"

    success: (data) ->
      my_data = data

    complete: ->
      $(".loading-text").remove()
      attendanceChart(my_data)
  )

attendanceChart = (dataset) ->
  # Dimensions and spacing for the chart and bars
  barPadding = 2
  chartPadding = 4
  barWidth = 14
  w = (dataset.length * (barWidth + (barPadding * 2)) + (chartPadding * 2))
  h = 600

  #Create SVG element
  svg = d3.select("#attendance_chart").append("svg").attr("width", w).attr("height", h)
  svg.selectAll("rect").data(dataset).enter().append("rect")
    .attr("x", (d, i) -> i * (w / dataset.length))
    .attr("y", (d) -> h - ((d.character.attendance * h) / 100))
    .attr("width", (w / (dataset.length - barPadding)) - chartPadding)
    .attr("height", (d) -> ((d.character.attendance * h) / 100))
    .attr "fill", (d) -> "rgb(0, 0, " + ((d.character.attendance * 255) / 100).toFixed(0) + ")"

  svg.selectAll("text").data(dataset).enter().append("text")
    .text((d) -> d.character.name)
    .attr("x", (h * -1) + 2)
    .attr("y", (d, i) -> chartPadding + barPadding + (i * (w / dataset.length)) + 4)
    .attr("font-family", "sans-serif").attr("font-size", "10px")
    .attr("fill", "white")
    .attr("transform", "rotate(-90)")

jQuery ->
  getAttendanceData()
