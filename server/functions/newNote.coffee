models = require '../models'
Notes = models.Notes


newNote = (title, id, user) ->
	newNoteData = new Notes
		title: title
		message: ''
		id: id
		deleted: 0
		user: user
		date: new Date().getTime()
	newNoteData.save (err, note) ->
		if err
			return console.error(err)
			console.log 'new note saved'


module.exports = newNote