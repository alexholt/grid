express = require 'express'
Landing = require './controllers/Landing'

class Server
  constructor: ->
    @app = express()
    @setupViews()
    @setupStaticDir()
    @setupRoutes()

  setupRoutes: ->
    @controllers = []
    @controllers.push new Landing @app

  setupStaticDir: ->
    @app.use '/assets', express.static('./public')
    @app.use '/src/browser', express.static('./src/browser')

  setupViews: ->
    @app.set 'view engine', 'jade'
    @app.set 'views', './views'

  listen: (port) ->
    @app.listen port

module.exports = Server
