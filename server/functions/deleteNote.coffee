db = require "../db"
Item = db.models.Item

module.exports = (id, user, cb) ->
  Item.findOne {_id: id, user: user}, (err, data) ->
    return cb err if err?
    data.deleted = true
    data.save (err) ->
      cb err, data
