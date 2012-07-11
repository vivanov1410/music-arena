# Requires and Variables
require("coffee-script")

express = require 'express'
stylus = require 'stylus'
routes = require './routes'
cradle = require 'cradle'
io = require 'socket.io'

# Creating a Server
app = module.exports = express.createServer()
io.listen(app)

# App Configuration
app.configure () ->
    app.set 'view engine', 'jade'
    app.set 'views', __dirname + '/views'
    app.use express.favicon()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser()
    app.use express.session {secret: 'your secret here'}
    app.use express.logger { format: '\x1b[1m:method\x1b[0m \x1b[33m:url\x1b[0m :response-time ms' }
    app.use stylus.middleware { src: __dirname + '/views', dest: __dirname + '/public' }
    app.use app.router
    app.use express.static __dirname + '/public'
    app.use express.logger()
    
app.configure 'development', ->
    app.use express.errorHandler { dumpExceptions: true, showStack: true }
    app.set 'db-uri', 'localhost:5984'
    app.set 'db-name', 'musicarena'

app.configure 'production', ->
    app.use express.errorHandler { dumpExceptions: true, showStack: true }
    #host = 'https://app5797503.heroku:iloveyou123@app5797503.heroku.cloudant.com'
    app.set 'db-uri', 'http://exilium.iriscouch.com'
    app.set 'db-name', 'musicarena'

# DB Connection    
conn = new cradle.Connection app.set 'db-uri'
db = conn.database app.set 'db-name'

# Routing and View Rendering
app.get '/', routes.login
    
# Handling Post Requests
app.post '/login', (req, res) ->
    # user object
    data = req.body
    
    # check if there is a corresponding user in db
    db.get data.username, (err, doc) ->
        if not doc
            res.render 'login', {flash: 'No user found', title: 'Music Arena. Log in'}
        else
            if doc.password isnt data.password
                res.render 'login', {flash: 'Wrong password!', title: 'Music Arena. Log in'}
            else
                res.render 'index', {flash: 'Logged in!', title: 'Music Arena'}
    
app.post '/register', (req, res) ->
    data = req.body
    
    # check if username is in use
    db.get data.username, (err, doc) ->
        if doc
            res.render 'login', {flash: 'Username is in use', title: 'Music Arena. Log in'}
        else
            if data.password isnt data.confirm_password
                res.render 'login', {flash: 'Password does not match', title: 'Music Arena. Log in'}
            else
                delete data.confirm_password;
                db.save data.username, data, (db_err, db_res) ->
                    res.render 'login', {flash: 'User created', title: 'Music Arena. Log in'}

# Run App
port = process.env.PORT or 9294
app.listen port, -> console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env