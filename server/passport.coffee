passport = require 'passport'
passportTwitter = require 'passport-twitter'

config = require './config'
keys = require './keys'
models = require './models'


passportTwitter = passportTwitter.Strategy
Users = models.Users
Notes = models.Notes



# Set Passport variables
# 
#Twitter login
passport.use new passportTwitter
  consumerKey: keys.consumerKey
  consumerSecret: keys.consumerSecret
  callbackURL: 'http://'+ config.host + '/auth/twitter/callback'
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


module.exports = passport