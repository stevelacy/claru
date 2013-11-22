http = require 'http'
express = require 'express'
mongoose = require 'mongoose'


config = require './config'
app = require './express'
keys = require './keys'
models = require './models'
passport = require './passport'
server = require './httpserver'

require './sockets'
# Functions
newNote = require './functions/newNote'

mongoose.connect config.db


mongoose.connection.once 'connected', ->
	console.log 'connected to mongodb'





Users = models.Users
Notes = models.Notes








app.get '/', (req, res) ->
	return res.render 'index' unless req.user?
	q = Notes.find {user:req.user.id, deleted:0}
	q.sort({'date': -1})
	q.exec (err, notes) ->
		res.render 'index', {user:req.user, notes:notes}
	

app.get '/note/:id', (req, res) ->
	return res.redirect '/' unless req.user?
	noteId = req.params.id
	Notes.find { id:noteId, user:req.user.id, deleted:0}, (err, note) ->
		res.render 'note', {user:req.user, note:note, shareurl:config.shortUrlHost}

app.get '/logout', (req, res) ->
	req.logout()
	res.redirect '/'

app.get '/:share', (req, res) ->
	q = Notes.find {shareurl:req.params.share, deleted:0}
	q.sort({'date': -1})
	q.exec (err, notes) ->
		res.render 'share', {note:notes}


# Twitter
app.get '/auth/twitter', passport.authenticate('twitter')
app.get '/auth/twitter/callback',
	passport.authenticate 'twitter', {successRedirect:'/', falureRedirect:'/login'}





# Now for the app.post functions

app.post '/', (req, res) ->
	Notes.findOne {}, {}, {sort: {_id : -1}}, (err, note) ->
		if note 
			noteId = note.id + 1
		else
			noteId = 1

		newNote(req.body.newNote, noteId, req.user.id)
		res.redirect('/note/' + noteId)






server.listen config.port
console.log config.port