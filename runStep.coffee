exports.start = (casper) ->
  i = 0
  #capture snaps a defined selection of the page
  runStep = (casperState, step) ->
    @echo 'here'
    step = require("./scenarios/" + step)
    step.run casperState, self.selectors, (casp) ->
      counts.successCnt = counts.successCnt + 1
      if i is self.steps.length - 1
        casper.capture successDir + "/" + ACfilename,
          top: 0
          left: 0
          width: width
          height: height
        casper.captureSelector successDir + "/" + ACfilename, 'body'
        casper.echo "snapshot taken"
        done()
      else
        i = i + 1
        runStep casp, self.steps[i]
    , ->
      counts.failedCnt = counts.failedCnt + 1
      casper.capture failedDir + "/" + ACfilename,
        top: 0
        left: 0
        width: width
        height: height
      casper.captureSelector failedDir + "/" + FPfilename, 'body'
      casper.echo "snapshot taken after failure"

  runStep(casper, step)