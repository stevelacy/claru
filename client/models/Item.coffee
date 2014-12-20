fission = require '../app'

module.exports = fission.model
  props:
    title: 'string'
    content: 'string'
    _id: 'string'
  url: '/v1/items'
  idAttribute: '_id'
