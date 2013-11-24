models = require '../models'
Notes = models.Notes


unShareNote = (id, user, cb) ->

	saveNoteData = 
			shareurl: null
			date: new Date().getTime()
	query = {id:id.unshare, user:user}
	Notes.update query, saveNoteData, (err, number, response) ->
		return console.error err if err?
		console.log 'node Saved'
		cb id.share

module.exports = unShareNote