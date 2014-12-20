bcrypt = require 'bcrypt'
{Schema} = require 'mongoose'

noWrite = ->
  perms =
    read: true
    write: false
  return perms

hidden = ->
  perms =
    read: false
    write: false
  return perms

Model = new Schema

  name:
    type: String
    required: true
    authorize: noWrite

  email:
    type: String
    required: true
    index:
      unique: true
    authorize: noWrite

  username:
    type: String

  password:
    type: String
    required: true

  token:
    type: String
    authorize: noWrite

  image:
    type: String
    authorize: noWrite
    default: '/img/user.png'


  online:
    type: Boolean
    default: false
    authorize: noWrite

  created:
    type: Date
    default: Date.now
    authorize: noWrite

  lastModified:
    type: Date
    default: Date.now
    authorize: noWrite

Model.set 'toJSON', {getters:true, virtuals:true}
Model.set 'toObject', {getters:true, virtuals:true}


Model.pre 'save', (next) ->
  return next() unless @.isModified 'password'
  bcrypt.genSalt 10, (err, salt) =>
    return next err if err?
    bcrypt.hash @password, salt, (err, hash) =>
      return next err if err?
      @password = hash
      next()


Model.methods.comparePassword = (password, cb) ->
  bcrypt.compare password, @password, (err, match) ->
    return cb err if err?
    cb null, match



Model.methods.authorize = (req) ->
  perms =
    read: true
    write: (req.user.username is @username)
    delete: false
  return perms

Model.statics.authorize = ->
  perms =
    read: true
    write: false
  return perms

Model.statics.me = (req, cb) ->
  cb null, req.user

Model.statics.byHandle = ({query}, cb) ->
  return cb new Error 'Missing username parameter' unless typeof query.username is 'string' and query.username.length > 0
  @findOne {username:query.username}, cb

module.exports = Model
