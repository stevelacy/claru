{join} = require 'path'

module.exports =
  database: 'mongodb://localhost:27017/claru-test'
  mongo:
    url: 'mongodb://127.0.0.1:27017/claru-test'
    host: '127.0.0.1'
    port: 27017
    name: 'claru-test'
  token:
    secret: 'IhoiUHyu6gtghj'
  debug: false
