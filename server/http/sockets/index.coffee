socketioJwt = require 'socketio-jwt'
db = require '../../db'
server = require '../httpServer'
config = require '../../config'
log = require '../../lib/log'
io = require('socket.io')(server)

Item = db.models.Item

io.use socketioJwt.authorize
  secret: config.token.secret
  handshake: true


io.on 'connection', (socket) ->
  console.log 'connected'

  socket.on 'title', (data) ->
    return unless data.id?
    Item.findById data.id, (err, item) ->
      return log err if err?
      item.set title: data.title
      item.save (err, doc) ->
        log err if err?


  socket.on 'message', (data) ->
    return unless data.id?
    Item.findById data.id, (err, item) ->
      return log err if err?
      item.set message: data.message
      item.save (err, doc) ->
        log err if err?

module.exports = io
