exports.run = (casper, scenario, step, c, p, t, x) ->
  c.logWithTime scenario, step, " inside run"
  console.log "EXISTS WWE SUBNAV LINK: " + casper.visible(c.selectors.subNav_WWE_link)
  casper.mouse.move c.selectors.subNav_WWE_link
  casper.click c.selectors.subNav_WWE_link
  casper.wait 1000, ->
    c.logWithTime scenario, step, " about to call passed"
    p casper, step
