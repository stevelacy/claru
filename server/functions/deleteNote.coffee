models = require '../models'
Notes = models.Notes

deleteNote = (id, user) ->
	Notes.findOne {id:id, 'user':user}, (err, note) ->
		if err 
			console.log err
		else	
			note.deleted = 1
			note.save()


module.exports = deleteNote