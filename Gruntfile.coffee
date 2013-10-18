module.exports = (grunt) ->
  async = require("async")
  spawn = require('child_process').spawn
  growl = require('growl')
  criteria = require "./criteria.coffee"
  common = criteria.util()
  resolutionsToTest = require "./casperResolutions"
  userAgents = require "./casperUserAgents"
  userAgentsToTest = userAgents.get()
  script = 'casperjs.bat'

  grunt.loadNpmTasks 'grunt-contrib-clean'

  # Configure Grunt
  grunt.initConfig
    clean: ["RESULTS_SUCCESS","RESULTS_FAILED"]
  grunt.registerTask 'testAcceptanceCriteria', 'RUN ALL CRITERIA', () ->
    run this.async()

  grunt.registerTask 'default', ['clean','testAcceptanceCriteria']

  setupWork = (cb) ->
    workList = []
    for scenario of common.criteriaList
      i = 0
      while i < resolutionsToTest.list.length
        for userAgentType of userAgentsToTest
          args = ['casperTestRunner.coffee', scenario, resolutionsToTest.list[i][0], resolutionsToTest.list[i][1]]
          # pass type of device or browser
          args.push userAgentType
          # pass actual userAgent string
          args.push userAgentsToTest[userAgentType]
          console.log args
          workList.push async.apply(cmd, script, args, cb)
        i++
    workList

  run = (cb) ->
    cnt = 0
    startTime = Date.now()
    callback = (err, results) ->
      cnt = cnt + 1
      if cnt == (Object.keys(common.criteriaList).length  * resolutionsToTest.list.length)
        endTime = Date.now()
        console.log script + ' COMPLETED for all criteria in : ' + ((endTime - startTime) / 1000).toFixed(3).toString() + ' seconds'
        cb()
    workList = setupWork(callback)
    async.parallel workList,
      callback

  cmd = (script, args, callback) ->
    console.log(args)
    cmdProcess = spawn(script, args)
    cmdProcess.stdout.on "data", (data) ->
      msg = "" + data
      grunt.log.write msg + '\n-----------------------------------\n'

    cmdProcess.stderr.on "error", (data) ->
      msg = "" + data
      grunt.log.write msg

    cmdProcess.on "exit", (code) ->
      msg = ' COMPLETED  scenario: ' + args[1]  + ' userAgent: ' + args[4] + ' viewport:  ' + args[2] + ' x ' + args[3] + '\n-----------------------------------\n'
      grunt.log.write msg
      growlMsg(msg)
      callback(null, "")

  growlMsg = (msg) ->
    unless typeof (growl) is "undefined"
      growl msg,
        title: "STATUS UPDATE",
        priority: 1
