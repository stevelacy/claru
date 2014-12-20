mongoose = require 'mongoose'
tungsten = require 'tungsten'

config = require '../../config'
db = require '../../db'

User = db.models.User

module.exports = (email, password, cb) ->
  User.findOne email: email, (err, user) ->
    return cb err if err?
    return cb null, null unless user?
    user.comparePassword password, (err, match) ->
      return cb err if err?
      return cb null, null unless match
      date = new Date()
      expire = date + 345600000
      token = tungsten.encode
        exp: expire
        id: user._id
      , config.token.secret
      user.set token: token
      user.save (err, doc) ->
        return cb err if err?
        return cb null, doc
