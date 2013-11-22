models = require '../models'
Notes = models.Notes


shareNote = (id, user, cb) ->
	###
	Notes.findOne {}, {}, {sort: {shareurl: -1}}, (err, note) ->
		return console.log 'find error' if err?
		if note
			noteId = note.shareurl + 1
		else
			noteId = 1
	###
	saveNoteData = 
			shareurl: id.share
			date: new Date().getTime()
	query = {id:id.share, user:user}
	Notes.update query, saveNoteData, (err, number, response) ->
		return console.error err if err?
		console.log 'node Saved'
		cb id.share

module.exports = shareNote