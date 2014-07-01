db = require "../db"
Item = db.models.Item

module.exports = (title, _id, message, user, cb) ->
  noteData =
    title: title
    message: message
    user: user
    date: new Date().getTime()

  Item.update {_id: _id, user: user}, noteData, (err, data) ->
    cb err, data
