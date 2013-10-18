exports.util = ->
  common = ->
    #    default url
    @url = 'http://google.com'

    #    common criteria list
    @criteriaList = {}
    @criteriaList.googleSearch = ['googleSearch']
    @criteriaList.clickSearchResultLink = ['googleSearch', 'clickSearchResultLink']


    #    common selectors
    s = {}
    s.googleSearchForm = 'form[action="/search"]'
    s.googleSearchResultLink = 'ol#rso li:first-child div.rc h3.r a'
    @selectors = s

    @logWithTime = (scenario, step, action) ->
      timeStamp = new Date()
      console.log  'SCENARIO: ' + scenario + ' -> ' + timeStamp + " : " + action + ' in the step ' + step
      timeStamp

    @logTimeToComplete = (scenario, step, start) ->
      console.log 'completed ' + step + ' step of  ' + scenario + ' in ' + ((new Date() - start) / 1000).toFixed(3).toString() + ' secs'

    @waitFor = (casper, step, selector, next, pass, timeout) ->
      casper.waitForSelector selector, (->
        casper.then ->
          next()
        casper.then ->
          pass casper, step
      ), ->
        console.log "t"
        timeout casper, step
      return
    return
  new common()


