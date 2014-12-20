config = require './config'
log = require './lib/log'

log.info 'Starting with config', config
server = require './http'

server.listen config.port, ->
  log.info "Server running on #{config.port}"

module.exports = server
