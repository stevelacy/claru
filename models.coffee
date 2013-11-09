mongoose = require 'mongoose'

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
	date: type: String

userSchema.set 'autoIndex', false
noteSchema.set 'autoIndex', false

exports.Users = mongoose.model 'Users', userSchema
exports.Notes = mongoose.model 'Notes', noteSchema