CasperParallel
=========

Using Node.js async module to Run [casperjs](http://casperjs.org/) Scripts in parallel.


Features
=======
  * configurable list of User Agents to use for each scenario
  * configurable list of Viewports to use for each scenario
  * build modular scenario steps the can be reused for multiple scenarios
  * each combination of User Agent, Viewport, and Scenario run in parallel reducing time to complete suite
  * ability to run specified scenario, viewport, and user agent with command line arguments
  * separate User Agents and Viewports by device type phone, tablet and desktop
  * at the end of each step in the scenario, a screenshot is recorded in Success or Failure

Setup
=====

* Install [node.js](http://nodejs.org/)
* Install [Growl for Windows](http://www.growlforwindows.com/gfw/) *Note: THIS IS OPTIONAL
* `git clone git@github.com:ot-adam-moon/CasperParallel.git`
* `npm install .`
* Download latest [casperjs](http://casperjs.org/) zip
* Add batchbin dir to PATH Environment Variable *Ex: E:\casperjs\batchbin;
* `grunt`

Customize for your project
==========================

1: Set your url
 in ./common/configProj.coffee
 
    # common project specific configurations
    exports.get = ->
      c = {}
      c.url = 'http://google.com'
      c
      
Create you own Scenarios
========================
 Create a new scenario step .js or .coffee file and save it in the `scenarios` directory.
 The scenario skeleton should look like this:
 
  `javascript`
  
    exports.run = function (casper, scenario, step, c, p, t) {
       // casper js scripts go here
    };
    
  `coffeescript`
  
    exports.run = (casper, scenario, step, c, p, t) ->

    # casper js scripts go here
 
 
 Example scenario step: googleSearch.js
 `javascript`
  
    exports.run = function (casper, scenario, step, c, p, t) {
    // google search for 'bleacher report'
    c.logWithTime(scenario, step, ' inside run');
    casper.waitForSelector(c.selectors.googleSearchForm,
        function () {
            casper.fill(c.selectors.googleSearchForm, { q: "bleacher report" }, true);
            casper.then(function () {
                casper.waitUntilVisible(c.selectors.googleSearchResultLink, function () {
                        c.logWithTime(scenario, step, ' about to call passed');
                        p(casper, step);
                    },
                    function () {
                        c.logWithTime(scenario, step, ' about to call failed');
                        t(casper, step);
                    });
            });
        },
        function () {
            c.logWithTime(scenario, step, ' about to call failed');
            t(casper, step);
        });
    };
    
  `coffeescript`
 
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



 
Command List
------------

| grunt command | what it does  |
| ------------- |:-------------:|
| `grunt`|`run all scenarios for all device types and viewports in parallel`|
| `grunt --scenario navigateToWWEHome`|`run specified scenario for all viewports and useragents`|
| `grunt --scenario googleSearch --deviceType phone`|`run specified scenario for all phone viewports and useragents`|
| `grunt --scenario googleSearch --userAgentType iPhoneSafari`|`run specified scenario for userAgent specified`|



