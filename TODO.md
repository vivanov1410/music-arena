Stack
-----

* Create index page
* Add small user chat using websockets (sockets.io)


Backlog
-------

* Provide login using Google, Facebook, BrowserID
* Style Login page
* Separate Login from Registration
* Create Wiki with instructions

History
-------

* 10/07/12 Add stylus css framework
* 10/07/12 Add mocha testing environment
* 10/07/12 Separate configuration for different environments (dev, prod)
* 10/07/12 Deploy to heroku
* 09/07/12 Create login form using jade and couchdb 

Notes
---

* Install NodeJS with npm
* Install expressjs framework
	> npm install express -g
* Create folder structure using express
	> express --sessions --css stylus 
	> npm install (installs dependencies)
* Change NodeJS environment
	> NODE_ENV=production node app.js
* Use mocha as BDD javascript testing environment that compile coffee-script
	> mocha --compilers coffee:coffee-script
	Create test/ folder and name test file <Module>Test.coffee
* Change Heroku environment
	> heroku config:add NODE_ENV=production
* Specify connection string to Iris Couch like http!!!! 
	ex. 'http://exilium.iriscouch.com'
