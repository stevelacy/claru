{router} = require 'fission'

Index = require './pages/Index/View'
Login = require './pages/Login/View'
Item = require './pages/Item/View'


module.exports = router
  index:
    path: '/'
    view: Index
  item:
    path: '/item/:id'
    view: Item
  login:
    path: '/login'
    view: Login
