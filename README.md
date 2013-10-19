CasperParallel
=========

Using Node.js async module to Run CasperJS Scripts in parallel.

Motivation
==========
  *  be able to run any UI Automation Scripts against a configurable list of Viewports and UserAgents
  *  be able to run entire suite of UI Automation Scripts in parallel

Setup
=====

* Install [node.js](http://nodejs.org/)
* Install [Growl for Windows](http://www.growlforwindows.com/gfw/) *Note: THIS IS OPTIONAL
* `git clone git@github.com:ot-adam-moon/CasperParallel.git`
* `npm install .`
* Download latest [casperjs](http://casperjs.org/) zip
* Add batchbin dir to PATH Environment Variable *Ex: E:\casperjs\batchbin;
* `grunt`

Run all casper js scripts in parallel
----------------------------------------------

 grunt
 
Command List
------------

| grunt command | what it does  |
| ------------- |:-------------:|
| `grunt` | `git submodule update, git pull upstream master` |
| `grunt default` | `git pull upstream master` |



