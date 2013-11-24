io = require 'socket.io'
express = require 'express'
passport = require 'passport'
passportSocketIO = require 'passport.socketio'

config = require './config'
sessionStore = require './sessionstore'
server = require './httpserver'

deleteNote = require './functions/deleteNote'
saveNote = require './functions/saveNote'
shareNote = require './functions/shareNote'
unShareNote = require './functions/unShareNote'

io = io.listen server


io.set 'authorization', passportSocketIO.authorize
	passport: passport
	cookieParser: express.cookieParser
	key: config.session.key
	secret: config.session.secret
	store: sessionStore
	fail: (data, accept) ->
		console.log 'io session failed'
		accept null, true
	success: (data, accept) ->
		console.log 'io session success'
		accept null, true



io.sockets.on 'connection', (socket) ->
	return console.log 'socket error - user not authorized' unless socket.handshake.user?
	user = socket.handshake.user
	console.log __dirname
	socket.join user.id
	socket.on 'note', (note) ->
		socket.broadcast.to(user.id).emit 'note', {message:note.message, title:note.title, id:note.id}
		console.log note
		saveNote(note.title, note.id, note.message, user.id)
	socket.on 'delete', (note) ->
		console.log 'deleting note: ' + note.id
		deleteNote(note.id, user.id)

	socket.on 'share', (share) ->
		shareNote share, user.id, (data) ->
			socket.emit 'share', {share:data}

	socket.on 'unshare', (unshare) ->
		unShareNote unshare, user.id, (data) ->
			socket.emit 'unshare', {unshare:data}





#module.exports = io