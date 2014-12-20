isObjectId = require '../../lib/isObjectId'
db = require '../../db'
Item = db.model 'Item'

module.exports = (req, res, next) ->
  return res.status(403).end() unless req.user?

  Item.findOne _id: req.params.id, user: req.user._id
  .remove (err) ->
    return res.status(401).end() if err?
    res.status(200).end()
