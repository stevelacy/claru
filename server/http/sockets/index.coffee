tungsten = require 'tungsten'
socketioJwt = require 'socketio-jwt'
db = require '../../db'
server = require '../httpServer'
config = require '../../config'
log = require '../../lib/log'
io = require('socket.io')(server)

Item = db.models.Item
User = db.models.User

io.use socketioJwt.authorize
  secret: config.token.secret
  handshake: true


io.on 'connection', (socket) ->
  log.info 'io: connecting...'
  token = socket.handshake.query?.token
  return unless token?
  decoded = tungsten.decode token, config.token.secret
  return unless decoded?.id?

  User.findById decoded.id, (err, user) ->
    log err if err?
    return unless user?
    socket.handshake.user = user
    socket.join user._id

    log.info 'io: connected'

    socket.on 'update', (data) ->
      console.log data
      return unless data.id?
      Item.findById data.id, (err, item) ->
        return log.error err if err?
        item.set
          date: new Date().getTime()
          message: data.message
          title: data.title
        item.save (err, doc) ->
          log.error err if err?
          socket.broadcast.to(user._id).emit 'update', data: doc

    socket.on 'search', (data) ->
      return unless data?.term?
      q =
        title:
          $regex: data.term
          $options: 'i'

      Item.find q, (err, items) ->
        socket.emit 'search', items

module.exports = io
