models = require '../models'
Notes = models.Notes


saveNote = (title, id, message, user) ->
	saveNoteData = 
		title: title
		message: message
		id: id
		deleted: 0
		user: user
		date: new Date().getTime()

	query = {id:id, user:user}
	Notes.update query, saveNoteData, (err, number, response) ->
		if err 
			console.error err
		console.log 'node Saved'


module.exports = saveNote