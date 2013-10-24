require = patchRequire global.require
x = require('casper').selectXPath
config = (require "./common/config.coffee").init()
common = new config()
casper = require("casper").create
  verbose: common.verbose
  logLevel: common.logThreshold
  waitTimeout: common.timeout
url = common.url
scenario = casper.cli.get(0)
deviceType = casper.cli.get(1)
width = casper.cli.get(2)
height = casper.cli.get(3)
userAgentType = casper.cli.get(4)
userAgentString = casper.cli.get(5)
steps = []

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
casper.userAgent userAgentString  if userAgentString

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
  common.logWithTime(scenario, step, ' snapshot taken after pass')
  runSteps c

fail = (c, step) ->
  c.capture common.dirFailure + ACfilename.replace(/{step}/g, currentStep + '-' + step),
    top: 0
    left: 0
    width: width
    height: height
  c.captureSelector common.dirFailure + FPfilename.replace(/\{step\}/, currentStep + '-' + step), 'body'
  common.logWithTime(scenario, step, ' snapshot taken after failure');

currentStep = 0

runSteps = (c) ->
  if steps[currentStep]
    step = steps[currentStep]
    stepToRun = require("./scenarios/" + step + '.js')
    common.logWithTime(scenario, currentStep + 1, ' run');
    stepToRun.run c, scenario, step, common, pass, fail, x
    currentStep++
  else
    common.logWithTime('Run All Steps', 'Done', 'Exit()');

casper.start url

casper.then ->
  @viewport width, height

casper.then ->
  runSteps casper

casper.run ->
  @echo("Finished captures for " + url).exit()
