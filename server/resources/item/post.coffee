isObjectId = require '../../lib/isObjectId'
db = require '../../db'
Item = db.model 'Item'

canModify = ['title', 'content']

module.exports = (req, res, next) ->
  return res.status(403).end() unless req.user?
  return next new Error 'Invalid body' unless typeof req.body is 'object'

  # dont allow modification of reserved fields
  # canModify is the whitelist here
  delete req.body[k] for k,v of req.body when canModify.indexOf(k) is -1

  console.log req.body
  item = new Item req.body
  item.save (err, data) ->
    return res.status(500).send error: "item not created" if err?
    return res.status(200).send status: data
