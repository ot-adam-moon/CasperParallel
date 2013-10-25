module.exports = (grunt) ->
  async = require("async")
  spawn = require('child_process').spawn
  fs = require('fs')
  _ = require('lodash')
  path = require('path')
  PDF = require 'pdfkit'
  growl = require('growl')
  config = (require "./common/config.coffee").init()
  common = new config()
  workList = []
  argScenario = grunt.option('scenario')
  argDeviceType = grunt.option('deviceType')
  argUserAgentType = grunt.option('userAgent')

  grunt.loadNpmTasks 'grunt-contrib-clean'

  # Configure Grunt
  grunt.initConfig
    clean: [common.dirSuccess, common.dirFailure, 'RESULTS']
  grunt.registerTask 'testAcceptanceCriteria', 'RUN ALL CRITERIA', () ->
    run this.async()

  grunt.registerTask 'default', ['clean', 'testAcceptanceCriteria']

  setupWork = (deviceType, cb) ->
    if argScenario
      setupWorkForScenario argScenario, deviceType, cb
    else
      for scenario of common.criteriaList
        setupWorkForScenario scenario, deviceType, cb

  setupWorkForScenario = (scenario, deviceType, cb) ->
    if common.criteriaList[scenario].forDeviceType is deviceType or !common.criteriaList[scenario].forDeviceType
      i = 0
      while i < common.resolutions[deviceType].list.length
        if argUserAgentType
          args = ['casperTestRunner.coffee', scenario, deviceType, common.resolutions[deviceType].list[i][0],
                  common.resolutions[deviceType].list[i][1]]
          # pass type of device or browser
          args.push argUserAgentType
          # pass actual userAgent string
          args.push common.userAgents[deviceType][argUserAgentType]
          workList.push async.apply(cmd, common.getCasperJsExec(), args, cb)
        else
          for userAgentType of common.userAgents[deviceType]
            args = ['casperTestRunner.coffee', scenario, deviceType, common.resolutions[deviceType].list[i][0],
                    common.resolutions[deviceType].list[i][1]]
            # pass type of device or browser
            args.push userAgentType
            # pass actual userAgent string
            args.push common.userAgents[deviceType][userAgentType]
            workList.push async.apply(cmd, common.getCasperJsExec(), args, cb)
        i++


  run = (cb) ->
    cnt = 0
    startTime = Date.now()
    callback = (err, results) ->
      cnt = cnt + 1
      #      console.log cnt
      #      console.log workList.length
      if cnt == workList.length
        endTime = Date.now()
        doneMsg = common.getCasperJsExec() + ' COMPLETED for all criteria in : ' + ((endTime - startTime) / 1000).toFixed(3).toString() + ' seconds'
        growlMsg(doneMsg)
        console.log doneMsg
        cb()

    fs.mkdirSync('RESULTS')
    if argDeviceType
      setupWork(argDeviceType, callback) if common.resolutions[argDeviceType].active
    else
      setupWork('phone', callback) if common.resolutions['phone'].active
      setupWork('tablet', callback) if common.resolutions.tablet.active
      setupWork('desktop', callback) if common.resolutions.desktop.active


    async.parallel workList,
      callback

  cmd = (script, args, callback) ->
    cmdProcess = spawn(script, args)
    cmdProcess.stdout.on "data", (data) ->
      msg = "" + data
      grunt.log.write msg + '\n-----------------------------------\n'

    cmdProcess.stderr.on "error", (data) ->
      msg = "" + data
      grunt.log.write msg

    cmdProcess.on "exit", (code) ->
      msg = 'COMPLETED\nscenario: ' + args[1] + '\ndeviceType: ' + args[5] + '\nviewport:  ' + args[3] + ' x ' + args[4] + '\n-----------------------------------\n'
      path = common.dirSuccess + args[1] + '/' + args[2] + '/' + args[5] + '/' +  args[3] + 'x' + args[4] + '/'
      console.log path
      doc = new PDF
        info:
            Title: 'Test Document'
        size:
          [args[3] , args[4]+30]

      doc.fontSize(25).text('Successful Steps')
      files = fs.readdirSync path
      files = _.sortBy files

      j = 0
      imgPath = ''
      isPng = false
      while j < files.length
        console.log files[j]
        imgPath = path + files[j]
        if j>0
          doc.addPage()
                  .text('Step: ' + (j+1), 5,5)
                  .image(imgPath, 0,30)
        else
          doc.text('Step: ' + (j+1),5,5)
          doc.image(imgPath, 0, 30)
        j++
      doc.write 'RESULTS/'  + args[1] + '-' + args[2] + '-' + args[5] + '-' + args[3] + '-' + args[4] + '.pdf'

      grunt.log.write msg
      callback(null, "")
  growlMsg = (msg) ->
    unless typeof (growl) is "undefined"
      growl msg,
        title: "STATUS UPDATE",
        priority: 1