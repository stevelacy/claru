request = require 'superagent'
fission = require './app.coffee'
{router} = fission

Index = require './pages/Index/View'
Login = require './pages/Login/View'
Item = require './pages/Item/View'


router.route '/',
  view: Index
  el: 'content'
  title: fission.config.title

router.route '/item/:id',
  view: Item
  el: 'content'
  title: fission.config.title

router.route '/login',
  view: Login
  el: 'content'
  title: fission.config.title

router.route '/logout',
  view: ->
    window.localStorage.setItem 'token', ''
    request.post "#{fission.config.url}/logout?token=#{window._token}", (err, res) ->
      return console.log err if err?
      window.location = '/'

module.exports = router
