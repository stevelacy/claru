Sync = require 'ampersand-sync'

window.token = window.localStorage.getItem 'token'
module.exports = (method, model, options) ->
  if window.token?
    options.headers =
      'x-access-token': window.token
  Sync method, model, options
