http = require 'http'

express = require 'express'
mongoose = require 'mongoose'
io = require 'socket.io'
passport = require 'passport'
passportTwitter = require 'passport-twitter'
#passportFacebook = require 'passport-facebook'

keys = require './keys'
models = require './models'


app = express()
server = http.createServer(app)
io = io.listen(server)
passportTwitter = passportTwitter.Strategy
#passportFacebook = passportFacebook.Strategy
users = {}
host = 'node.la'
port = 5000
db = mongoose.connect 'mongodb://127.0.0.1:27017/claru'



mongoose.connection.once 'connected', ->
	console.log 'connected to mongodb'


app.configure () ->
	app.set 'view engine', 'jade'
	app.set 'views', __dirname + '/views'
	app.use express.static 'static'
	app.use express.json()
	app.use express.urlencoded()
	app.use express.methodOverride()
	app.use express.cookieParser()
	app.use express.session({
		secret: 'b1d8d68e863cbbf5b6eac491ad52972d2e8559369c34a5add78913eab3d9fa3d'
		maxAge: new Date(Date.now() + 3600000)
		expires: new Date(Date.now() + 3600000)
		})
	app.use passport.initialize()
	app.use passport.session()





Users = models.Users
Notes = models.Notes





# Set Passport variables
# 
#Twitter login
passport.use new passportTwitter
  consumerKey: keys.consumerKey
  consumerSecret: keys.consumerSecret
  callbackURL: 'http://'+ host + '/auth/twitter/callback'
, (token, tokenSecret, profile, done) ->
# Check it against the database:
		Users.findOne {id: profile.id}, (err, user) ->
			return done if err?
			userData = 
				username: profile.username
				name: profile.name
				id: profile.id
				source: 'twitter'
				icon: profile.photos[0].value
			if user?
				# user is already in database.  --TODO Add the login time to db
				user.set userData
				user.check = 0
				user.save done
				console.log 'returning user'
				return done null, user
			else 
				Users.create userData, (err, user) ->
					return done if err?
					done null, user
					console.log user	


passport.serializeUser (user, done) ->
	done null, user.id


passport.deserializeUser (id, done) ->
	Users.findOne {id: id}, done

#end passport variables








app.get '/', (req, res) ->
	return res.render 'index' unless req.user?
	q = Notes.find {user:req.user.id, deleted:0}
	q.sort({'date': -1})
	q.exec (err, notes) ->
		res.render 'index', {user:req.user, notes:notes}
		if req.user.check != 1
			req.user.check = 1
			socketAuthed(req.user)
	

app.get '/note/:id', (req, res) ->
	return res.redirect '/' unless req.user?
	noteId = req.params.id
	Notes.find { id:noteId, user:req.user.id, deleted:0}, (err, note) ->
		res.render 'note', {user:req.user, note:note}
		if req.user.check != 1
			req.user.check = 1
			socketAuthed(req.user)




#Twitter
app.get '/auth/twitter', passport.authenticate('twitter')
app.get '/auth/twitter/callback',
	passport.authenticate 'twitter', {successRedirect:'/', falureRedirect:'/login'}


app.get '/logout', (req, res) ->
	req.logout()
	res.redirect '/'


# Now for the app.post functions

app.post '/', (req, res) ->
	Notes.findOne {}, {}, {sort: {_id : -1}}, (err, note) ->
		if note 
			noteId = note.id + 1
		else
			noteId = 1

		newNote(req.body.newNote, noteId, req.user.id)
		res.redirect('/note/' + noteId)







# Functions

newNote = (title, id, user) ->
	newNoteData = new Notes
		title: title
		message: ''
		id: id
		deleted: 0
		user: user
		date: new Date().getTime()
	newNoteData.save (err, note) ->
		if err
			return console.error(err)
			console.log 'new note saved'

saveNote = (title, id, message, user) ->
	saveNoteData = 
		title: title
		message: message
		id: id
		deleted: 0
		user: user
		date: new Date().getTime()

	query = {id:id, user:user}
	Notes.update query, saveNoteData, (err, number, response) ->
		if err 
			console.error err
		console.log 'node Saved'

deleteNote = (id, user) ->
	Notes.findOne {id:id, 'user':user}, (err, note) ->
		if err 
			console.log err
		else	
			note.deleted = 1
			note.save()



# Sockets!
socketAuthed = (user) ->
	io.sockets.on 'connection', (socket) ->
		console.log __dirname
		socket.join user.id
		socket.on 'note', (note) ->
			socket.broadcast.to(user.id).emit 'note', {message:note.message, title:note.title, id:note.id}
			console.log note
			saveNote(note.title, note.id, note.message, user.id)
		socket.on 'delete', (note) ->
			console.log 'deleting note: ' + note.id
			deleteNote(note.id, user.id)

server.listen port
console.log port