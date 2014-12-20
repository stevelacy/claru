mongoose = require 'mongoose'
tungsten = require 'tungsten'

config = require '../config'

date = new Date()
createId = String mongoose.Types.ObjectId()

token = tungsten.encode
  id: createId
  exp: date + 345600000
, config.token.secret


module.exports =
  user:
    _id: createId
    name: 'John Smith'
    token: token
    email: 'me@my.me'
    password: 'sosecure'
    username: 'jsmith'

  item:
    _id: createId
    name: 'test-item'
    main: 'test.coffee'
    widget:
      html: 'test.html'
