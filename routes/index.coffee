exports.index = (req, res) ->
    res.render 'index', { title: 'Music Arena.Home' }
    
exports.login = (req, res) ->
    res.render 'login', { title: 'Music Arena. Log in' }