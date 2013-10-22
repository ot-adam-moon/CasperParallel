module.exports = (grunt) ->
  async = require("async")
  spawn = require('child_process').spawn
  growl = require('growl')
  config = (require "./config/config.coffee").init()
  !common = new config()
  workList = []

  grunt.loadNpmTasks 'grunt-contrib-clean'

  # Configure Grunt
  grunt.initConfig
    clean: [common.dirSuccess,common.dirFailure]
  grunt.registerTask 'testAcceptanceCriteria', 'RUN ALL CRITERIA', () ->
    run this.async()

  grunt.registerTask 'default', ['clean','testAcceptanceCriteria']

  setupWork = (deviceType, cb) ->
    for scenario of common.criteriaList
      if common.criteriaList[scenario].forDeviceType is deviceType or !common.criteriaList[scenario].forDeviceType
        i = 0
        while i < common.resolutions[deviceType].list.length
          for userAgentType of common.userAgents[deviceType]
            args = ['casperTestRunner.coffee', scenario, deviceType, common.resolutions[deviceType].list[i][0], common.resolutions[deviceType].list[i][1]]

            # pass type of device or browser
            args.push userAgentType
            # pass actual userAgent string
            args.push  common.userAgents[deviceType][userAgentType]
            workList.push async.apply(cmd, common.getCasperJsExec(), args, cb)
          i++

  run = (cb) ->
    cnt = 0
    startTime = Date.now()
    callback = (err, results) ->
      cnt = cnt + 1
      console.log cnt
      console.log workList.length
      if cnt == workList.length
        endTime = Date.now()
        console.log common.getCasperJsExec() + ' COMPLETED for all criteria in : ' + ((endTime - startTime) / 1000).toFixed(3).toString() + ' seconds'
        cb()

    setupWork('phone',callback) if common.resolutions['phone'].active
    setupWork('tablet',callback) if common.resolutions.tablet.active
    setupWork('desktop',callback) if common.resolutions.desktop.active

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
      msg = 'COMPLETED\nscenario: ' + args[1]  + '\ndeviceType: ' + args[5] + '\nviewport:  ' + args[3] + ' x ' + args[4] + '\n-----------------------------------\n'
      grunt.log.write msg
      growlMsg(msg)
      callback(null, "")

  growlMsg = (msg) ->
    unless typeof (growl) is "undefined"
      growl msg,
        title: "STATUS UPDATE",
        priority: 1
