isObjectId = require '../../lib/isObjectId'
db = require '../../db'
Item = db.model 'Item'

module.exports = (req, res, next) ->
  return res.status(403).end() unless req.user?
  return next new Error('Invalid id parameter') unless typeof req.params.id is 'string'

  q = Item.findOne _id: req.params.id, user: req.user._id
  q.exec (err, item) ->
    return next err if err?
    return res.status(404).end() unless item?

    res.status(200).json item
