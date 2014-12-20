fission = require '../app'

module.exports = fission.model
  props:
    title: 'string'
    message: 'string'
    _id: 'string'
  url: "#{fission.config.url}/v1/items"
  idAttribute: '_id'
