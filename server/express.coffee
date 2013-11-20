http = require 'http'
express = require 'express'
passport = require 'passport'
config = require './config'
sessionStore = require './sessionstore'
app = express()




app.configure () ->
	app.set 'view engine', 'jade'
	app.set 'views', 'views'
	app.use express.static 'static'
	app.use express.json()
	app.use express.urlencoded()
	app.use express.methodOverride()
	app.use express.cookieParser()
	app.use express.session({
		store: sessionStore
		key: config.session.key
		secret: config.session.secret
		maxAge: new Date(Date.now() + 3600000)
		expires: new Date(Date.now() + 3600000)
		})
	app.use passport.initialize()
	app.use passport.session()


	module.exports = app