exports.get = ->
  resolutions =
    phone:
      active: true
    tablet:
      active: true
    desktop:
      active: true
  resolutions.phone.list = [[320, 568], [568, 320]]
  resolutions.tablet.list = [[1024, 768], [768, 1024]]
  resolutions.desktop.list = [[1920, 1080],  [1080, 1920]]
  resolutions