tungsten = require 'tungsten'
db = require '../../db'
config = require '../../config'

User = db.model 'User'

module.exports = (req, res, next) ->

  #token = req.body and req.body.access_token or req.body and req.query.access_token or req.headers['x-access-token']
  token = if req.query?.token then req.query.token else req.headers['x-access-token']
  return next() unless token?
  try
    decoded = tungsten.decode token, config.token.secret
    if decoded.exp <= Date.now() or decoded.exp == null or decoded.exp == undefined
      return next()
    User.findById decoded.id, (err, user) ->
      return next() if err?
      req.user = user
      return next()
  catch e
    return next()
