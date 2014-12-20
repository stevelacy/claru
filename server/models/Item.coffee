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

  title:
    type: String

  message:
    type: String

  user:
    type: Schema.Types.ObjectId
    required: true

  deleted:
    type: Boolean
    default: false

Model.set 'toJSON', {getters:true, virtuals:true}
Model.set 'toObject', {getters:true, virtuals:true}

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

module.exports = Model
