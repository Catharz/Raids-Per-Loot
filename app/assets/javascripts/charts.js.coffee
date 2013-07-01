getAttendanceData = ->
  my_data = null
  $.ajax(
    type: "GET"
    url: "/characters/attendance.json"
    beforeSend: ->
      $("#attendance_chart").append "<p class=\"loading-text\">Loading attendance details...</p>"

    success: (data) ->
      my_data = data
      my_data

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
  h = 500

  svg = d3.select("#attendance_chart")
    .append("svg")
    .attr("width", w)
    .attr("height", h)

  ap_div = d3.select("#attendance_chart")
    .append("div")
    .attr("class", "tooltip")
    .attr("id", "attendance_popup")
    .style("opacity", 0)

  svg.selectAll("rect").data(dataset).enter()
    .append("rect")
    .on("mouseover",(d) ->
      ap_div.transition().duration(200).style "opacity", .9
      ap_div.html((d.character.attendance).toFixed(2) + "%")
        .style("left", (d3.event.pageX) + "px")
        .style "top", (d3.event.pageY - 100) + "px"
    ).on("mouseout",(d) ->
    ap_div.transition()
      .duration(500)
      .style("opacity", 0)
  ).attr("x", (d, i) ->
      i * (w / dataset.length))
    .attr("y", (d) ->
      h - ((d.character.attendance * h) / 100))
    .attr("width", (w / (dataset.length - barPadding)) - chartPadding)
    .attr("height", (d) ->
      ((d.character.attendance * h) / 100))
    .attr "fill", (d) ->
      "rgb(0, 0, " + ((d.character.attendance * 255) / 100).toFixed(0) + ")"

  svg.selectAll("text").data(dataset).enter().append("text")
    .text((d) ->
      d.character.name)
    .attr("x", (h * -1) + 2)
    .attr("y", (d, i) ->
      chartPadding + barPadding + (i * (w / dataset.length)) + 4)
    .attr("font-family", "sans-serif").attr("font-size", "10px")
    .attr("fill", "white")
    .attr("transform", "rotate(-90)")

getHealthData = ->
  url = "http://data.soe.com/json/get/eq2/character/"
  params =
    "locationdata.world": "Unrest"
    "guild.name": "Southern Cross"
    "type.level": 95
    "c:limit": 50
    "c:sort": "stats.health.max:-1"
    "c:show": "name.first,type.level,stats.health.max"

  $.getJSON url + "?callback=?", params, (data) ->
    healthChart data.character_list

healthChart = (dataset) ->
  barPadding = 2
  chartPadding = 4
  barWidth = 14
  w = dataset.length * (barWidth + (barPadding * 2)) + (chartPadding * 2)
  h = 500

  svg = d3.select("#health_chart")
    .append("svg")
    .attr("width", w)
    .attr("height", h)

  hp_div = d3.select("#health_chart")
    .append("div")
    .attr("class", "tooltip")
    .attr("id", "health_popup")
    .style("opacity", 0)

  svg.selectAll("rect").data(dataset).enter().append("rect")
    .on("mouseover",(d) ->
      hp_div.transition().duration(200).style "opacity", .9
      hp_div.html(d.stats.health.max)
        .style("left", (d3.event.pageX) + "px")
        .style "top", (d3.event.pageY - 100) + "px"
    ).on("mouseout",(d) ->
    hp_div.transition()
      .duration(500)
      .style("opacity", 0)
  ).attr("x",(d, i) ->
    i * (w / dataset.length)
  ).attr("y",(d) ->
    h - ((d.stats.health.max * h) / 100000)
  ).attr("width", (w / (dataset.length - barPadding)) - chartPadding).attr("height",(d) ->
    (d.stats.health.max * h) / 100000
  ).attr "fill", (d) ->
    if d.stats.health.max < 50000
      "rgb(" + (d.stats.health.max / 200).toFixed(0) + ", 0, 0)"
    else
      "rgb(0, " + ((d.stats.health.max - 50000) / 200).toFixed(0) + ", 0)"
  svg.selectAll("text").data(dataset).enter().append("text").text((d) ->
    d.name.first
  ).attr("x", (h * -1) + 2).attr("y",(d, i) ->
    chartPadding + barPadding + (i * (w / dataset.length)) + 4
  ).attr("font-family", "sans-serif").attr("font-size", "10px").attr("fill", "white").attr "transform", "rotate(-90)"

getAttendanceData()
getHealthData()