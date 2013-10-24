exports.run = (casper, scenario, step, c, p, t, x) ->
  c.logWithTime scenario, step, " inside run"
  casper.show c.selectors.globalNav_WWE_link
  console.log "EXISTS WWE LINK: " + casper.visible(c.selectors.globalNav_WWE_link)
  casper.mouse.move c.selectors.globalNav_WWE_link
  casper.click c.selectors.globalNav_WWE_link
  casper.wait 1000, ->
    c.logWithTime scenario, step, " about to call passed"
    p casper, step
