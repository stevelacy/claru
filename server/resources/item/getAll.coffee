isObjectId = require '../../lib/isObjectId'
db = require '../../db'
Item = db.model 'Item'

module.exports = (req, res, next) ->
  return res.status(403).end() unless req.user?

  # return all
  q = Item.find()
  q.select '-token'
  q.limit 25

  q.exec (err, users) ->
    return next err if err?
    res.status(200).json users
