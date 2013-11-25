models = require '../models'
Todos = models.Todos


saveTodo = (id, user, cb) ->
	saveTodoData = 
			title: '<- TODO ->'
			date: new Date().getTime()


	query = {id:id.share, user:user}
	Todos.update query, saveTodoData, (err, number, response) ->
		return console.error err if err?
		console.log 'node Saved'
		cb id.share

module.exports = saveTodo