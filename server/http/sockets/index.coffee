socketioJwt = require 'socketio-jwt'
db = require '../../db'
server = require '../httpServer'
config = require '../../config'
io = require('socket.io')(server)

Item = db.models.Item

io.use socketioJwt.authorize
  secret: config.token.secret
  handshake: true


io.on 'connection', (socket) ->
  console.log 'connected'

  socket.on 'test', (data) ->
    console.log 'test worked', data
    socket.emit 'test', test: 'that'

  socket.on 'title', (data) ->
    return unless data.id?
    Item.findById data.id, (err, item) ->
      item.set title: data.title
      item.save (err, doc) ->
        console.log err, doc


  socket.on 'content', (data) ->
    return unless data.id?
    Item.findById data.id, (err, item) ->
      item.set content: data.content
      item.save (err, doc) ->
        console.log err, doc

module.exports = io
