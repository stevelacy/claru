request = require 'superagent'

module.exports = ->
  window.localStorage.removeItem 'token'
  request.post "#{window._config.url}/logout?token=#{window.token}", (err, res) ->
    console.log err if err?
    setTimeout ->
      window.location = '/login'
    , 1000
