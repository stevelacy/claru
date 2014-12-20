request = require 'superagent'
fission = require '../app'

module.exports = ->
  window.localStorage.setItem 'token', ''
  request.post "#{fission.config.url}/logout?token=#{window._token}", (err, res) ->
    return console.log err if err?
    fission.router.route '/'
