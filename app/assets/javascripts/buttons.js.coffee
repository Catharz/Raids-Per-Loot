decorateButtons = () ->
  $(".button").button()
  $(".table-button").button()
  $(".button-set").buttonset()

jQuery ->
  decorateButtons()
