request = require 'superagent'
fastclick = require 'fastclick'
io = require 'socket.io-client'
router = require './router'

fastclick document.body

window.socket = io '',
  query: "token=#{window.token}"

request.post "#{window._config.url}/auth?token=#{window.token}", (err, res) ->
  if res.status is 200
    window._user = res?.body
  else
    window.localStorage.removeItem 'token'
    window.token = undefined
  router.start document.body
