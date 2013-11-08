exports.init = ->
  config = ->
#   casper runner config properties
    @browserEngine = 'phantomjs'
#    @browserEngine = 'slimerjs'
#    @verbose = false
    @verbose = true
#    @logThreshold = 'debug'
    @logThreshold = 'error'
    @scenarioScriptExt = '.coffee'
    @generatePdf = true
    @timeout = 5000
    @dirSuccess = "RESULTS_SUCCESS/"
    @dirFailure = "RESULTS_FAILURE/"
    @pdfResults = "RESULTS/"
    @includeFullPage = true
    @dirScreenshotViewPort = '{scenario}/{deviceType}/{userAgentType}/{width}x{height}/STEP-{step}.png'
    @dirScreenshotFullPage = '{scenario}/{deviceType}/{userAgentType}/FULLPAGE/{width}x{height}/STEP-{step}.png'
    @passedColor = "#00FF00"
    @failedColor="#8A0808"
    self = @

#    set criteria list
    @proj =  (require('./configProject')).get()
    @criteriaList =  (require('./criteria')).get()
#    set selectors
    @selectors =  (require('./selectors')).get()
#    set resolutions
    @viewPorts =  (require('./viewPorts')).get()
#    set userAgents
    @userAgents =  (require('./userAgents')).get()
#    common helper methods
    @setupScreenShotPath = (scenario,deviceType,userAgentType,width,height, fullpage) ->
      path = if fullpage then self.dirScreenshotFullPage else self.dirScreenshotViewPort
      path = path.replace('{scenario}', scenario)
        .replace('{deviceType}', deviceType)
        .replace('{userAgentType}', userAgentType)
        .replace('{width}', width)
        .replace('{height}', height)
      path

    @getCasperJsExec = () ->
      "casperjs"
    @logWithTime = (scenario, step, action) ->
      if self.verbose
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
        timeout casper, step
      return
    return
  config