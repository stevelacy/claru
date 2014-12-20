mongoose = require 'mongoose'
tungsten = require 'tungsten'

config = require '../config'

date = new Date()
itemId = String mongoose.Types.ObjectId()
userId = String mongoose.Types.ObjectId()

token = tungsten.encode
  id: userId
  exp: date + 345600000
, config.token.secret


module.exports =
  user:
    _id: userId
    name: 'John Smith'
    token: token
    email: 'me@my.me'
    password: 'sosecure'
    username: 'jsmith'

  item:
    _id: itemId
    name: 'test-item'
    main: 'test.coffee'
    user: userId
    widget:
      html: 'test.html'
