request = require 'superagent'
fission = require '../app'

module.exports = ->
  window.localStorage.setItem 'token', ''
  request.post "#{fission.config.url}/logout?token=#{window._token}", (err, res) ->
    console.log err if err?
    setTimeout ->
      fission.router.route '/login'
    , 1000
