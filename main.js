// Generated by CoffeeScript 1.3.3
(function() {
  var app, conn, cradle, db, exp, host, port;

  require("coffee-script");

  exp = require('express');

  cradle = require('cradle');

  app = exp.createServer();

  app.configure(function() {
    app.set('view engine', 'jade');
    app.set('views', __dirname + '/views');
    app.use(exp["static"](__dirname + '/public'));
    app.use(exp.logger());
    app.use(exp.bodyParser());
    return app.use(exp.methodOverride());
  });

  host = 'https://app5797503.heroku:iloveyou123@app5797503.heroku.cloudant.com';

  port = 80;

  conn = new cradle.Connection(host, port);

  db = conn.database('musicarena');

  app.get('/', function(req, res) {
    return res.render('login', {
      title: 'Music Arena. Log in'
    });
  });

  app.post('/login', function(req, res) {
    var data;
    data = req.body;
    return db.get(data.username, function(err, doc) {
      if (!doc) {
        return res.render('login', {
          flash: 'No user found'
        });
      } else {
        if (doc.password !== data.password) {
          return res.render('login', {
            flash: 'Wrong password!'
          });
        } else {
          return res.render('index', {
            flash: 'Logged in!'
          });
        }
      }
    });
  });

  app.post('/register', function(req, res) {
    var data;
    data = req.body;
    return db.get(data.username, function(err, doc) {
      if (doc) {
        return res.render('login', {
          flash: 'Username is in use'
        });
      } else {
        if (data.password !== data.confirm_password) {
          return res.render('login', {
            flash: 'Password does not match'
          });
        } else {
          delete data.confirm_password;
          return db.save(data.username, data, function(db_err, db_res) {
            return res.render('login', {
              flash: 'User created'
            });
          });
        }
      }
    });
  });

  port = process.env.PORT || 9294;

  app.listen(port, function() {
    return console.log("Server is running on port: " + port);
  });

}).call(this);
