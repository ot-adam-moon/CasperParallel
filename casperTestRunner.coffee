require = patchRequire global.require
x = require('casper').selectXPath
config = (require "./common/config.coffee").init()
common = new config()
casper = require("casper").create
  verbose: common.verbose
  logLevel: common.logThreshold
  waitTimeout: common.timeout
url = common.proj.url
scenario = casper.cli.get(0)
deviceType = casper.cli.get(1)
width = casper.cli.get(2)
height = casper.cli.get(3)
userAgentType = casper.cli.get(4)
steps = []
successCount = 0
failedCount = 0
successImgPath = ''
failureImgPath = ''

buildSteps = (scenario) ->
  for st in common.criteriaList[scenario].steps
    if common.criteriaList[st] and common.criteriaList[st].steps.length > 1
      buildSteps st
    else
      steps.push st

buildSteps(scenario)

ACfilename = common.setupScreenShotPath scenario, deviceType, userAgentType, width, height, false
FPfilename = common.setupScreenShotPath scenario, deviceType, userAgentType, width, height, true

#set the userAgent from argument passed in
casper.userAgent common.userAgents[deviceType][userAgentType]

casper.show = (selector) ->
  @evaluate ((selector) ->
    document.querySelector(selector).style.display = "block !important;"
  ), selector

pass = (c, step)->
  c.capture common.dirSuccess + ACfilename.replace(/{step}/g, currentStep + '-' + step),
    top: 0
    left: 0
    width: width
    height: height
  if common.includeFullPage
    c.captureSelector common.dirSuccess + FPfilename.replace(/{step}/g, currentStep + '-' + step), 'body'

  common.logWithTime scenario, step, ' snapshot taken after pass'
  successCount = successCount + 1 
  runSteps c

fail = (c, step) ->
  c.capture common.dirFailure + ACfilename.replace(/{step}/g, currentStep + '-' + step),
    top: 0
    left: 0
    width: width
    height: height
  c.captureSelector common.dirFailure + FPfilename.replace(/\{step\}/, currentStep + '-' + step), 'body'

  common.logWithTime scenario, step, ' snapshot taken after failure'
  failedCount = failedCount + 1

exit = () ->
  exitCode = successCount*10 + failedCount
#  c.echo("Exiting with exit code " + exitCode)
  casper.exit exitCode

currentStep = 0

runSteps = (c) ->
  if steps[currentStep]
    step = steps[currentStep]
    stepToRun = require("./scenarios/" + step + common.scenarioScriptExt)
    common.logWithTime(scenario, currentStep + 1, ' run')
    stepToRun.run c, scenario, step, common, pass, fail, x
    currentStep++

casper.start url

casper.then ->
  @viewport width, height

casper.then ->
  runSteps casper

casper.run ->
  exit()
