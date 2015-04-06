Server = require './src/server/Server'

argv = require('minimist')(process.argv.slice(2))

usage = ->
  console.log """
      Usage:
        coffee app.js
  """

do ->
  server = new Server
  server.listen 3333
