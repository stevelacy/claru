models = require '../models'
Todoitems = models.Todoitems


newTodoitem = (todoitem, user, cb) ->
	Todoitems.findOne {}, {}, {sort:{id: -1}}, (err, lastitem) ->
		if lastitem
			itemId = lastitem.id + 1
		else
			itemId = 1

		newTodoData = new Todoitems
			todoid: todoitem.todoid
			id: itemId
			deleted: 0
			user: user
			title: todoitem.title
			date: new Date().getTime()
		newTodoData.save (err, note) ->
			if err
				return console.error(err)
			console.log 'new note saved'
			cb todoitem


module.exports = newTodoitem