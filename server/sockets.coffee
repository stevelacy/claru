passport = require 'passport'
cookieParser = require 'cookie-parser'
passportSocketIO = require 'passport.socketio'

config = require '../config'
sessionStore = require './sessionstore'
server = require './httpserver'

deleteNote = require './functions/deleteNote'
saveNote = require './functions/saveNote'


io = require('socket.io')(server)


io.set 'authorization', passportSocketIO.authorize
  cookieParser: cookieParser
  key: config.session.name
  secret: config.session.secret
  store: sessionStore
  fail: (data, message, critical, accept) ->
    console.log 'io session failed'
    accept null, false
  success: (data, accept) ->
    console.log 'io session success'
    accept null, true



io.on 'connection', (socket) ->
  return console.log 'socket error - user not authorized' unless socket.client.request.user?
  user = socket.client.request.user
  socket.join user.id
  socket.on 'note', (note) ->
    socket.broadcast.to(user.id).emit 'note', {message:note.message, title:note.title, id:note.id}
    console.log note
    saveNote note.title, note.id, note.message, user._id, (err, data) ->
      console.log err if err?
  socket.on 'delete', (note) ->
    console.log 'deleting note: ' + note.id
    deleteNote note.id, user._id, (err, data) ->
      console.log err if err?
      console.log "deleted"

  socket.on 'share', (share) ->
    shareNote share, user.id, (data) ->
      socket.emit 'share', {share:data}

  socket.on 'unshare', (unshare) ->
    unShareNote unshare, user.id, (data) ->
      socket.emit 'unshare', {unshare:data}


module.exports = io
