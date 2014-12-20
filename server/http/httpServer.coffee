http = require 'http'
app = require './express'

module.exports = http.createServer app
