config = require "../config"
require "./webapp"
require "./sockets"
server = require "./httpserver"

server.listen config.port
