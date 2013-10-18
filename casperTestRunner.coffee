require = patchRequire global.require

casper = require("casper").create
  verbose: true
  logLevel: "error"
criteria = require "./criteria.coffee"
common = criteria.util()
url = common.url
successDir = "RESULTS_SUCCESS"
failedDir = "RESULTS_FAILED"
scenario = casper.cli.get(0)
width = casper.cli.get(1)
height = casper.cli.get(2)
userAgentType = casper.cli.get(3)
userAgentString = casper.cli.get(4)
steps = common.criteriaList[scenario]
ACfilename = scenario + "/" + userAgentType + "/STEP-{step}" + width + "-" + height+ '.png'
FPfilename = scenario + "/" + userAgentType + "/STEP-{step}" + "-" + width + "-" + height + "-" + "fullPage"+ '.png'


#set the userAgent from argument passed in
casper.options.waitTimeout = 5000
casper.userAgent userAgentString  if userAgentString

pass = (c, step)->
  c.capture successDir + "/" + ACfilename.replace(/\{step\}/, currentStep+'-'+step),
    top: 0
    left: 0
    width: width
    height: height
  c.captureSelector successDir + "/" + FPfilename.replace(/{step}/g, currentStep+'-'+step), 'body'
  common.logWithTime(scenario, step, ' snapshot taken after pass')
  runSteps c

fail = (c, step) ->
  c.capture failedDir + "/" + ACfilename.replace(/{step}/g, currentStep+'-'+step) ,
    top: 0
    left: 0
    width: width
    height: height
  c.captureSelector failedDir + "/" + FPfilename.replace(/\{step\}/, currentStep+'-'+step), 'body'
  common.logWithTime(scenario, step, ' snapshot taken after failure');

currentStep = 0

runSteps = (c) ->
  if steps[currentStep]
    step = steps[currentStep]
    stepToRun = require("./scenarios/" + step + '.js')
    common.logWithTime(scenario, currentStep+1, ' run');
    stepToRun.run c, scenario, step, common, pass, fail
    currentStep++
  else
    common.logWithTime('Run All Steps', 'Done', 'Exit()');
    c.exit()

casper.start url

casper.then ->
  @viewport width, height

casper.run runSteps casper



