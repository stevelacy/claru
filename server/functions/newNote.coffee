db = require "../db"
Item = db.models.Item

module.exports = (title, user, cb) ->
  console.log Item
  newNote = new Item
  noteData =
    title: title
    message: " "
    user: user
    date: new Date().getTime()

  newNote.set noteData
  newNote.save (err, data) ->
    cb err, data
