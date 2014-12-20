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

module.exports = router
