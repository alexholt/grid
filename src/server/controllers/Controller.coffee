class Controller
  constructor: (@app) ->
    @setupRoutes()

  setupRoutes: ->
    for route, method of @routes
      @app.get route, @[method]

module.exports = Controller
