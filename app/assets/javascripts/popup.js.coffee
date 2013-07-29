jQuery ->
  configurePopups = ->
    hideDelay = 500
    currentID = undefined
    hideTimer = null
    ajaxCall = null

    container = $("<div id=\"popupContainer\">" + "<table width=\"\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" class=\"popupPopup\">" + "<tr>" + "   <td class=\"corner topLeft\"></td>" + "   <td class=\"top\"></td>" + "   <td class=\"corner topRight\"></td>" + "</tr>" + "<tr>" + "   <td class=\"left\">&nbsp;</td>" + "   <td><div id=\"popupContent\"></div></td>" + "   <td class=\"right\">&nbsp;</td>" + "</tr>" + "<tr>" + "   <td class=\"corner bottomLeft\">&nbsp;</td>" + "   <td class=\"bottom\">&nbsp;</td>" + "   <td class=\"corner bottomRight\"></td>" + "</tr>" + "</table>" + "</div>")

    $("body").append container

    $(".itemPopupTrigger").live "mouseover", ->
      if ajaxCall
        ajaxCall.abort()
        ajaxCall = null

      currentID = @id
      return  if currentID is ""

      clearTimeout hideTimer  if hideTimer

      pos = $(this).offset()
      width = $(this).width()

      container.css
        left: (pos.left + width) + "px"
        top: (pos.top - 5) + "px"

      $("#popupContent").html "&nbsp;"

      ajaxCall = $.ajax(
        type: "GET"
        url: "/items/" + currentID + "/info"
        beforeSend: ->
          $("#popupContent").prepend "<p class=\"loading-text\">Loading item details...</p>"

        success: (data) ->
          $("#popupContent").html "<span >Did not return a valid result for item id " + currentID + ".  Please have your administrator check the error log.</span>"  if data.indexOf("itemPopupResult") < 0
          if data.indexOf(currentID) > 0
            $("#popupContent").empty()
            $("#popupContent").append data

        complete: ->
          $(".loading-text").remove()
      )
      container.css "display", "block"

    $(".itemPopupTrigger").live "mouseout", ->
      clearTimeout hideTimer  if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

    $(".characterPopupTrigger").live "mouseover", ->
      if ajaxCall
        ajaxCall.abort()
        ajaxCall = null

      data = $(this).parent().data()
      currentID = data.character_id
      return  if currentID is undefined

      clearTimeout hideTimer  if hideTimer

      pos = $(this).offset()
      width = $(this).width()

      container.css
        left: (pos.left + width) + "px"
        top: (pos.top - 5) + "px"

      $("#popupContent").html "&nbsp;"

      ajaxCall = $.ajax(
        type: "GET"
        url: "/characters/" + currentID + "/info"
        beforeSend: ->
          $("#popupContent").prepend "<p class=\"loading-text\">Loading character details...</p>"

        success: (data) ->
          $("#popupContent").html "<span >Did not return a valid result for character " + currentID + ".  Please have your administrator check the error log.</span>"  if data.indexOf("characterPopupResult") < 0
          if data.indexOf(currentID) > 0
            $("#popupContent").empty()
            $("#popupContent").append data

        complete: ->
          $(".loading-text").remove()
      )
      container.css "display", "block"

    $(".characterPopupTrigger").live "mouseout", ->
      clearTimeout hideTimer  if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

    $(".lootRateTrigger").live "mouseout", ->
      clearTimeout hideTimer  if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

    $(".playerLootRateTrigger").live "mouseout", ->
      clearTimeout hideTimer  if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

    $(".lootRateTrigger").live "mouseover", ->
      data = $(this).parent().data()
      currentID = data.character_id
      return  if currentID is undefined

      clearTimeout hideTimer  if hideTimer

      pos = $(this).offset()
      width = $(this).width()

      container.css
        left: (pos.left + width) + "px"
        top: (pos.top - 5) + "px"

      $("#popupContent").empty()
      $("#popupContent").append "<div class='popupResult'>" +
      "Raids (Player): " + data.player_raids + "</br>" +
      "Raids (Character): " + data.raids + "</br>" +
      "Instances: " + data.instances + "</br>" +
      "Switches: " + data.switches + "</br></br>" +
      "Armour: " + data.armour + "</br>" +
      "Jewellery: " + data.jewellery + "</br>" +
      "Weapons: " + data.weapons + "</br>" +
      "Attuned: " + data.attuned + "</br></br>" +
      "Adornments: " + data.adornments + "</br>" +
      "Dislodgers: " + data.dislodgers + "</br></br>" +
      "Mounts: " + data.mounts + "</div>"
      container.css
        display: "block"

    $(".playerLootRateTrigger").live "mouseover", ->
      data = $(this).parent().data()
      currentID = data.player_id
      return  if currentID is undefined

      clearTimeout hideTimer  if hideTimer

      pos = $(this).offset()
      width = $(this).width()

      container.css
        left: (pos.left + width) + "px"
        top: (pos.top - 5) + "px"

      $("#popupContent").empty()
      $("#popupContent").append "<div class='popupResult'>" +
      "Raids: " + data.raids + "</br>" +
      "Switches: " + data.switches + "</br>" +
      "Instances: " + data.instances + "</br></br>" +
      "Armour: " + data.armour + "</br>" +
      "Jewellery: " + data.jewellery + "</br>" +
      "Weapons: " + data.weapons + "</br>" +
      "Attuned: " + data.attuned + "</br></br>" +
      "Adornments: " + data.adornments + "</br>" +
      "Dislodgers: " + data.dislodgers + "</br></br>" +
      "Mounts: " + data.mounts + "</div>"
      container.css
        display: "block"

    $(".adornmentsTrigger").live "mouseout", ->
      clearTimeout hideTimer  if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

    $(".adornmentsTrigger").live "mouseover", ->
      currentID = @parentElement.id
      return if currentID is ""

      clearTimeout hideTimer  if hideTimer

      pos = $(this).offset()
      width = $(this).width()

      container.css
        left: (pos.left + width) + "px"
        top: (pos.top - 5) + "px"

      data = $(this).parent().data()
      $("#popupContent").empty()
      $("#popupContent").append "<div class='popupResult'>" +
      "White: " + data.white_adornments + "</br>" +
      "Yellow: " + data.yellow_adornments + "</br>" +
      "Red: " + data.red_adornments + "</br>" +
      "Green: " + data.green_adornments + "</br>" +
      "Blue: " + data.blue_adornments + "</div>"
      container.css
        display: "block"

    $("#popupContainer").mouseover ->
      clearTimeout hideTimer if hideTimer

    $("#popupContainer").mouseout ->
      clearTimeout hideTimer if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

  $(document).ready(configurePopups)
