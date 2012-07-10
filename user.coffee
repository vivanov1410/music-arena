# User Class - Handles all user functions
cradle = require 'cradle'

class User
    constructor: (host, port) ->
        @connect = new cradle.Connection host, port, {
            cache: true
            raw: false
        }
        @db = @connect.database 'musicarena'
        
        findAll: (callback) ->
            @db.view 'musicarena/all', {descending: true}, (err, res) ->
                if (err)
                    callback err
                else
                    docs = []
                    res.forEach (row) ->
                        docs.push row
                    callback null, docs
        
        save: (users, callback) ->
            @db.save users, (err, res) ->
                if (err)
                    callback err
                else
                    callback null, users
    
    exports.User = User