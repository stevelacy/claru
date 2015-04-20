{model} = require 'fission'
sync = require './sync'

module.exports = model
  props:
    title: 'string'
    message: 'string'
    _id: 'string'
  urlRoot: "#{window._config.url}/v1/items"
  idAttribute: '_id'
  sync: sync
