Controller = require './Controller'

class Landing extends Controller
  routes:
    '/': 'landing'

  constructor: ->
    super

  landing: (req, res) ->
    res.render 'index.jade'

module.exports = Landing
