http = require 'http'
config = require '../config'

app = require './express'

# handle auth on incoming requests
auth = require './auth'

# serve our APIs
apis = require './apis'

# catch-all serve index.html
spa = require './express/spa'

sockets = require './sockets'

httpServer = require './httpServer'


module.exports = httpServer
