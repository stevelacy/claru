isObjectId = require '../../lib/isObjectId'
db = require '../../db'
Item = db.model 'Item'

module.exports = (req, res, next) ->
  return res.status(403).end() unless req.user?

  Item.findOneAndUpdate {_id: req.params.id, user: req.user._id}, {deleted: true}, (err, item) ->
    return res.status(401).end() if err?
    return res.status(404).end() unless item?
    res.status(204).end()
