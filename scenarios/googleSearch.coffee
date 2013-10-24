exports.run = (casper, scenario, step, c, p, t) ->
  
  # google search for 'bleacher report'
  c.logWithTime scenario, step, " inside run"
  casper.waitForSelector c.selectors.googleSearchForm, (->
    casper.fill c.selectors.googleSearchForm,
      q: "bleacher report"
    , true
    casper.then ->
      casper.waitUntilVisible c.selectors.googleSearchResultLink, (->
        c.logWithTime scenario, step, " about to call passed"
        p casper, step
      ), ->
        c.logWithTime scenario, step, " about to call failed"
        t casper, step

  ), ->
    c.logWithTime scenario, step, " about to call failed"
    t casper, step
