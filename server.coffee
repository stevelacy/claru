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





Users = models.Users
Notes = models.Notes





# Set Passport variables
# 
#Twitter login
passport.use new passportTwitter(
  consumerKey: keys.consumerKey
  consumerSecret: keys.consumerSecret
  callbackURL: 'http://'+ host + '/auth/twitter/callback'
, (token, tokenSecret, profile, done) ->
# Check it against the database:
	Users.findOne {'username' : profile.username}, (err, user) ->
		if user
			# user is already in database.  --TODO Add the login time to db
		else 
				Register = new Users 
					'username': profile.username
					'name': profile.name
					'id': profile.id
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


passport.serializeUser (user, done) ->
	done null, user.id


passport.deserializeUser (id, done) ->
	#Users.findOne {'id': id}, done
	user = users[id]
	done null, user

#end passport variables








app.get '/', (req, res)->
	if req.user
		Notes.find {user:req.user.id, deleted:0}, (err, notes) ->
			res.render 'index', {user:req.user, notes:notes}
			socketAuthed(req.user)
	else
		res.render 'index' #, {user:req.user, notes:notes}
	

app.get '/note/:id', (req, res) ->
	noteId = req.params.id
	Notes.find { id:noteId, user:req.user.id}, (err, note) ->
		res.render 'note', {user:req.user, note:note}




#Twitter
app.get '/auth/twitter', passport.authenticate('twitter')
app.get '/auth/twitter/callback',
	passport.authenticate 'twitter', {successRedirect:'/', falureRedirect:'/auth/twitter'}


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

	query = {id:id, user:userAuthId}
	Notes.update query, saveNoteData, (err, number, response) ->
		if err 
			console.error err
		console.log 'node Saved'

deleteNote = (id, user) ->
	Notes.findOne {id:id, 'user':user}, (err, note) ->
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
			deleteNote(note.id, user.id)

server.listen port
console.log port