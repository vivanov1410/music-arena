# Requires and Variables
require("coffee-script")

exp = require 'express'
cradle = require 'cradle'

# Creating a Server
app = exp.createServer()

# App Configuration
app.configure () ->
    app.set 'view engine', 'jade'
    app.set 'views', __dirname + '/views'
    app.use exp.static __dirname + '/public'
    app.use exp.logger()
    app.use exp.bodyParser()
    app.use exp.methodOverride()
    
conn = new cradle.Connection();
db = conn.database 'musicarena';

# Routing and View Rendering
app.get '/', (req, res) ->
    res.render 'login', {title: 'Music Arena. Log in'}
    
# Handling Post Requests
app.post '/login', (req, res) ->
    # user object
    data = req.body
    
    # check if there is a corresponding user in db
    db.get data.username, (err, doc) ->
        if not doc
            res.render 'login', {flash: 'No user found'}
        else
            if doc.password isnt data.password
                res.render 'login', {flash: 'Wrong password!'}
            else
                res.render 'index', {flash: 'Logged in!'}
    
app.post '/register', (req, res) ->
    data = req.body
    
    # check if username is in use
    db.get data.username, (err, doc) ->
        if doc
            res.render 'login', {flash: 'Username is in use'}
        else
            if data.password isnt data.confirm_password
                res.render 'login', {flash: 'Password does not match'}
            else
                delete data.confirm_password;
                db.save data.username, data, (db_err, db_res) ->
                    res.render 'login', {flash: 'User created'}

# Run App
port = process.env.PORT or 9294
app.listen port, -> console.log "Server is running on port: #{port}"