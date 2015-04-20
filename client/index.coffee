request = require 'superagent'
io = require 'socket.io-client'
router = require './router'

window.socket = io '',
  query: "token=#{window.token}"

request.post "#{window._config.url}/auth?token=#{window.token}", (err, res) ->
  window._user = res?.body

  router.start document.body
