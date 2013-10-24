CasperParallel
=========

Using Node.js async module to Run [casperjs](http://casperjs.org/) Scripts in parallel.
Features
=======
  * configurable list of User Agents to use for each scenario
  * configurable list of Viewports to use for each scenario
  * build modular scenario steps that can be reused for multiple scenarios
  * each combination of User Agent, Viewport, and Scenario run in parallel reducing time to complete suite
  * ability to run specific combination of scenario, viewport, and user agent with command line arguments
  * separate User Agents and Viewports by device type phone, tablet and desktop
  * at the end of each step in the scenario, a screenshot is recorded in directory `RESULTS_SUCCESS` or `RESULTS_FAILURE` to capture the state of the browser after each step

Setup
=====

* Install [node.js](http://nodejs.org/)
* Install [Growl for Windows](http://www.growlforwindows.com/gfw/) *Note: THIS IS OPTIONAL
* `git clone git@github.com:ot-adam-moon/CasperParallel.git`
* `npm install .`
* Download latest [casperjs](http://casperjs.org/) zip
* Add batchbin dir to PATH Environment Variable *Ex: E:\casperjs\batchbin;
* `grunt`

Command List
------------
| grunt command | what it does  |
| ------------- |:-------------:|
| `grunt`|`run all scenarios for all device types and viewports in parallel`|
| `grunt --scenario navigateToWWEHome`|`run specified scenario for all viewports and useragents`|
| `grunt --scenario googleSearch --deviceType phone`|`run specified scenario for all phone viewports and useragents`|
| `grunt --scenario googleSearch --userAgentType iPhoneSafari`|`run specified scenario for userAgent specified`|


Customize for your project
==========================
1: Set your url
 in ./common/configProj.coffee
 
    # common project specific configurations
    exports.get = ->
      c = {}
      c.url = 'http://google.com'
      c
      
2: Create your own Scenarios Steps

 Create a new scenario step .js or .coffee file and save it in the `scenarios` directory.
 The scenario skeleton should look like this:
 
  `javascript`
  
    exports.run = function (casper, scenario, step, c, p, t) {
       // casper js scripts go here
    };
    
  `coffeescript`
  
    exports.run = (casper, scenario, step, c, p, t) ->

    # casper js scripts go here
 
 Add the casperjs code to complete the step you are trying to simulate.
 
 Use the latest [casperjs API Dcumentation](http://docs.casperjs.org/en/latest/index.html)
 
 
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
    
  Example scenario step: googleSearch.coffee
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
        
 Use [./common/selectors.coffee](https://github.com/ot-adam-moon/CasperParallel/blob/master/common/selectors.coffee) to save common css3 or xpath selectors in one place.
 They then can be referenced in your custom scenario step with `c.selectors.selectorYouCreated`
 
    exports.get = ->
      s = {}
      s.googleSearchForm = 'form[action="/search"]'
      s.googleSearchResultLink = 'div#search a:first-child'
      s.bleacherReportNavToggle = "div#nav_handle a"
      s.globalNav_WWE_link = 'ul.nav_list li[data-id="wwe"] > a'
      s.subNav_WWE_link = '#sub-nav-region > ul > li:first-child > a'
      s
      
3: Configure your acceptance criteria in ./common/criteria.coffee
   
    exports.get = ->
    # common criteria list
    criteriaList = {}
    criteriaList.googleSearch =
      steps: ["googleSearch"]
    
    criteriaList.browseToSearchResult =
      steps: ['googleSearch', 'clickSearchResultLink']
    
    criteriaList.navigateToBleachReportNavLink  =
        forDeviceType: "phone"
        steps: ['browseToSearchResult','clickNavToggleBtn']
    
    criteriaList.navigateToWWEHome  =
        forDeviceType: "phone"
        steps: ['navigateToBleachReportNavLink', 'clickWWENavLink','clickWWESubNavLink']
    
    criteriaList
    
4: Configure the resolutions you want to test in ./common/resolutions.coffee

    exports.get = ->
     resolutions =
       phone:
         active: true
       tablet:
         active: true
       desktop:
         active: true
     resolutions.phone.list = [[320, 568], [568, 320]]
     resolutions.tablet.list = [[1024, 768], [768, 1024]]
     resolutions.desktop.list = [[1920, 1080],  [1080, 1920]]
     resolutions
     
5: Configure the userAgents you want to test in ./common/userAgents.coffee

    exports.get = () ->
     ua = { phone: {}, tablet: {}, desktop: {}}
     #  phone user agents
     ua.phone.GoogleNexus="Mozilla/5.0 (Linux; Android 4.0.4; Galaxy Nexus Build/IMM76B) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.133 Mobile Safari/535.19"
     ua.phone.iPhoneSafari="Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543 Safari/419.3"
     # tablet user agents
     ua.tablet.iPadSafari="Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10"
     # desktop user agents
     ua.desktop.ChromeDesktop="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.151 Safari/535.19"
     ua.desktop.SafariDesktop="cd /5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.53.11 (KHTML, like Gecko) Version/5.1.3 Safari/534.53.10"
     ua

