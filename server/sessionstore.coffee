express = require 'express'
connectMongo = require 'connect-mongo'

config = require './config'

mongoStore = connectMongo express

mongoStore = new mongoStore({
	url: config.mongo.url
	})

module.exports = mongoStore