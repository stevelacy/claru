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
	date: type: Number
	shareurl: type: String


todoSchema = new mongoose.Schema
	title: type: String
	id: type: Number
	deleted: type: Number
	user: type: Number
	date: type: Number

todoitemSchema = new mongoose.Schema
	todoid: type: Number
	id: type: Number
	user: type: Number
	date: type: Number
	title: type: String
	checked: type: Number
	deleted: type: Number	
	#_todo: [{type: mongoose.Schema.Types.ObjectId, ref: 'Todos'}]




userSchema.set 'autoIndex', false
noteSchema.set 'autoIndex', false
todoSchema.set 'autoIndex', false
todoitemSchema.set 'autoIndex', false

exports.Users = mongoose.model 'Users', userSchema
exports.Notes = mongoose.model 'Notes', noteSchema
exports.Todos = mongoose.model 'Todos', todoSchema
exports.Todoitems = mongoose.model 'Todoitems', todoitemSchema