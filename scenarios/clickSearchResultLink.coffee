exports.run = (casper, scenario, step, c, p, t, x) ->
  c.logWithTime scenario, step, " inside run"
  casper.waitUntilVisible c.selectors.googleSearchResultLink, (->
    casper.mouse.move c.selectors.googleSearchResultLink
    casper.click c.selectors.googleSearchResultLink
    casper.then ->
      casper.waitForUrl /(.*)(report.com)/, ->
        c.logWithTime scenario, step, " about to call passed"
        p(casper, step)

  ), ->
    c.logWithTime scenario, step, " about to call timeout"
    t casper, step
