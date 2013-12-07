jQuery ->
  configurePopups = ->
    hideDelay = 500
    currentID = undefined
    hideTimer = null
    ajaxCall = null

    container = $("<div id=\"popupContainer\">" + "<table width=\"\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" class=\"popupPopup\">" + "<tr>" + "   <td class=\"corner topLeft\"></td>" + "   <td class=\"top\"></td>" + "   <td class=\"corner topRight\"></td>" + "</tr>" + "<tr>" + "   <td class=\"left\">&nbsp;</td>" + "   <td><div id=\"popupContent\"></div></td>" + "   <td class=\"right\">&nbsp;</td>" + "</tr>" + "<tr>" + "   <td class=\"corner bottomLeft\">&nbsp;</td>" + "   <td class=\"bottom\">&nbsp;</td>" + "   <td class=\"corner bottomRight\"></td>" + "</tr>" + "</table>" + "</div>")

    $("body").append container

    $(document).on "mouseover", ".itemPopupTrigger", ->
      if ajaxCall
        ajaxCall.abort()
        ajaxCall = null

      currentID = @id
      currentID = this.parentElement.parentElement.id if currentID is ""
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

    $(document).on "mouseout", ".itemPopupTrigger", ->
      clearTimeout hideTimer  if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

    $(document).on "mouseover", ".characterPopupTrigger", ->
      if ajaxCall
        ajaxCall.abort()
        ajaxCall = null

      data = $(this).parent().data()
      currentID = data.character_id || data.characterId
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

    $(document).on "mouseout", ".characterPopupTrigger", ->
      clearTimeout hideTimer  if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

    $(document).on "mouseout", ".lootRateTrigger", ->
      clearTimeout hideTimer  if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

    $(document).on "mouseout", ".playerLootRateTrigger", ->
      clearTimeout hideTimer  if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

    $(document).on "mouseover", ".lootRateTrigger", ->

      data = $(this).parent().data()
      currentID = data.character_id || data.characterId
      return if currentID is undefined

      clearTimeout hideTimer if hideTimer

      pos = $(this).offset()
      width = $(this).width()

      container.css
        left: (pos.left + width) + "px"
        top: (pos.top - 5) + "px"

      playerRaids = data.player_raids || data.playerRaids
      popupContent = $("#popupContent")
      popupContent.empty()
      popupContent.append "<div class='popupResult'>"
      popupContent.append "Raids (Player): " + playerRaids + "</br>"
      popupContent.append "Raids (Character): " + data.raids + "</br>"
      popupContent.append "Instances: " + data.instances + "</br>"
      popupContent.append "Switches: " + data.switches + "</br></br>"
      popupContent.append "Armour: " + data.armour + "</br>"
      popupContent.append "Jewellery: " + data.jewellery + "</br>"
      popupContent.append "Weapons: " + data.weapons + "</br>"
      popupContent.append "Attuned: " + data.attuned + "</br></br>"
      popupContent.append "Adornments: " + data.adornments + "</br>"
      popupContent.append "Dislodgers: " + data.dislodgers + "</br></br>"
      popupContent.append "Mounts: " + data.mounts + "</div>"

      container.css
        display: "block"

    $(document).on "mouseover", ".playerLootRateTrigger", ->
      data = $(this).parent().data()
      currentID = data.player_id || data.playerId
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

    $(document).on "mouseout", ".adornmentsTrigger", ->
      clearTimeout hideTimer  if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

    $(document).on "mouseover", ".adornmentsTrigger", ->
      clearTimeout hideTimer  if hideTimer

      pos = $(this).offset()
      width = $(this).width()

      container.css
        left: (pos.left + width) + "px"
        top: (pos.top - 5) + "px"

      data = $(this).parent().data()
      $("#popupContent").empty()
      $("#popupContent").append "<div class='popupResult'>" +
      "White: " + data.whiteAdornments + "</br>" +
      "Yellow: " + data.yellowAdornments + "</br>" +
      "Red: " + data.redAdornments + "</br>" +
      "Green: " + data.greenAdornments + "</br>" +
      "Purple: " + data.purpleAdornments + "</br>" +
      "Blue: " + data.blueAdornments + "</div>"
      container.css
        display: "block"

    $("#popupContainer").mouseover ->
      clearTimeout hideTimer if hideTimer

    $("#popupContainer").mouseout ->
      clearTimeout hideTimer if hideTimer
      hideTimer = setTimeout ->
        container.css "display", "none", hideDelay

  $(document).ready(configurePopups)
