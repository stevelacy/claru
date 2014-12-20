isObjectId = require '../../lib/isObjectId'
db = require '../../db'
Item = db.model 'Item'

module.exports = (req, res, next) ->
  return res.status(403).end() unless req.user?

  # return all
  q = Item.find user: req.user._id, deleted: false
  q.limit 25

  q.exec (err, items) ->
    return next err if err?
    res.status(200).json items
