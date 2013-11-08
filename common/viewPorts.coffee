exports.get = ->
  viewPorts =
    phone:
      active: true
    tablet:
      active: true
    desktop:
      active: true
  viewPorts.phone.list = [[320, 568], [568, 320]]
  viewPorts.tablet.list = [[1024, 768], [768, 1024]]
  viewPorts.desktop.list = [[1920, 1080],  [1080, 1920]]
  viewPorts