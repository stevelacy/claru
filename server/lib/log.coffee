bunyan = require 'bunyan'
config = require '../config'


logger = bunyan.createLogger
  name: config.name


module.exports = logger
