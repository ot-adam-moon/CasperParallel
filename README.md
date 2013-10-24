casperallel
=========

Using Node.js async module to Run [casperjs](http://casperjs.org/) Scripts in parallel.

Motivation
==========
  *  be able to run any UI Automation Scripts against a configurable list of Viewports and UserAgents
  *  be able to run entire suite of UI Automation Scripts in parallel

Features
=======
  * configurable list of User Agents to use for each scenario
  * configurable list of Viewports to use for each scenario
  * nestable predefined scenarios to reduce verbose repeated steps
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

Run all casper js ui acceptance criteria scenarios in parallel
-----------------------------------------------------------------------------

 grunt
 
Command List
------------

| grunt command | what it does  |
| ------------- |:-------------:|
| `grunt` | `clean RESULT folders`, `run all scenarios for all device types and viewports in parallel` |
| `grunt default` | `git pull upstream master` |



