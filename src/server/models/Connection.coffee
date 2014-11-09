mongoose = require 'mongoose'

db = null

exports.setDB = (dbName) ->
  db = mongoose.createConnection "mongodb://localhost/#{dbName}", slaveOk: true

exports.getDB = ->
  throw new Error("setDb must be called first") unless db?
  db
