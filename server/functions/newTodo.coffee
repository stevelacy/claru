models = require '../models'
Todos = models.Todos


newTodo = (title, id, user) ->
	newTodoData = new Todos
		title: title
		message: ''
		id: id
		deleted: 0
		user: user
		date: new Date().getTime()
	newTodoData.save (err, note) ->
		if err
			return console.error(err)
			console.log 'new note saved'


module.exports = newTodo