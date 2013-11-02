http = require 'http'

express = require 'express'
mongoose = require 'mongoose'
io = require 'socket.io'
passport = require 'passport'
passportTwitter = require 'passport-twitter'
#passportFacebook = require 'passport-facebook'

keys = require './keys'


app = express()
server = http.createServer(app)
io = io.listen(server)
passportTwitter = passportTwitter.Strategy
#passportFacebook = passportFacebook.Strategy
users = {}
userAuthId = ''
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











userSchema = new mongoose.Schema 
  username: type: String
  name: type: String
  id: type: Number
  icon: type: String
  source: String



noteSchema = new mongoose.Schema
	title: type: String
	message: type: String
	id: type: Number
	deleted: type: Number
	user: type: Number

userSchema.set 'autoIndex', false
noteSchema.set 'autoIndex', false

Users = mongoose.model 'Users', userSchema
Notes = mongoose.model 'Notes', noteSchema

###
note = new Notes
	title: 'Note Title'
	message: 'Note Message'		
	id: 1
	deleted: 0
	user: 1

note.save()
###



# Set Passport variables
# 
#Twitter login
passport.use new passportTwitter(
  consumerKey: keys.consumerKey
  consumerSecret: keys.consumerSecret
  callbackURL: 'http://'+ host + '/auth/twitter/callback'
, (token, tokenSecret, profile, done) ->
# Check it against the database:
	Users.findOne 'username' : profile.username, (err, user) ->
		if user
			# user is already in database.  --TODO Add the login time to db
			# Set the global user id
			userAuthId = user.id
		else 
			# Get the last user id and add 1 to it
			Users.findOne {}, {}, sort: _id: -1, (err, user) ->
				if user
					newId = user.id + 1
				else
					newId = 1
				# Set the global user id
				userAuthId = newId
				# user is not registered. Register it
				Register = new Users 
					'username': profile.username
					'name': profile.name
					'id': userAuthId
					'source': 'twitter'
					'icon': profile.icon
				Register.save()
				console.log 'registering user'
			
			


# Set the user vars as needed:
  user = users[profile.id] or (users[profile.id] =
    id: profile.id
    username: profile.username
    name: profile.displayName
    icon: profile.photos[0].value
  )
  done null, user
  #console.log profile
 
) # end passportTwitter

# Facebook login
###
passport.use new passportFacebook(
  clientID: '1431883733699728'
  clientSecret: '50e03dc7c6147347e63366bf32d7e6a3'
  callbackURL: "http://node.la/auth/facebook/callback"
, (accessToken, refreshToken, profile, done) ->
# get FB user info	
	user = users[profile.id] or (users[profile.id] =
    id: profile.id
    username: profile.username
    name: profile.displayName
    icon: 'http://graph.facebook.com/' + profile.id + '/picture'
  )
  done null, user
  console.log profile
)
###


passport.serializeUser (user, done) ->
	done null, user.id


passport.deserializeUser (id, done) ->
	user = users[id]
	done null, user

#end passport variables








app.get '/', (req, res)->
	Notes.find {user:userAuthId, deleted:0}, (err, notes) ->
		res.render 'index', {user:req.user, notes:notes}
	

app.get '/note/:id', (req, res) ->
	noteId = req.params.id
	Notes.find { id:noteId, user:userAuthId}, (err, note) ->
		res.render 'note', {user:req.user, note:note}




#Twitter
app.get '/auth/twitter', passport.authenticate('twitter')
app.get '/auth/twitter/callback',
	passport.authenticate 'twitter', {successRedirect:'/', falureRedirect:'/auth/twitter'}

###	 Facebook
app.get '/auth/facebook', passport.authenticate('facebook', {scope: 'email'})
app.get '/auth/facebook/callback',
	passport.authenticate 'facebook', {successRedirect: '/', falureRedirect: '/auth/facebook'}
###


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

		newNote(req.body.newNote, noteId)
		res.redirect('/note/' + noteId)







# Functions

newNote = (title, id) ->
	newNoteData = new Notes
		title: title
		message: ''
		id: id
		deleted: 0
		user: userAuthId
	newNoteData.save (err, note) ->
		if err
			return console.error(err)
			console.log 'new note saved'

saveNote = (title, id, message) ->
	saveNoteData = 
		title: title
		message: message
		id: id
		deleted: 0
		user: userAuthId

	query = {id:id, user:userAuthId}
	Notes.update query, saveNoteData, (err, number, response) ->
		if err 
			console.error err
		console.log 'node Saved'

deleteNote = (id) ->
	Notes.findOne {id:id}, (err, note) ->
		note.deleted = 1
		note.save()



# Sockets!

io.sockets.on 'connection', (socket) ->
	console.log __dirname
	socket.join userAuthId
	socket.on 'note', (note) ->
		socket.broadcast.to(userAuthId).emit 'note', {message:note.message, title:note.title, id:note.id}
		console.log note
		saveNote(note.title, note.id, note.message)
	socket.on 'delete', (note) ->
		deleteNote(note.id)

server.listen port
console.log port