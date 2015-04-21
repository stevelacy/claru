{router} = require 'fission'

Index = require './pages/Index/View'
Login = require './pages/Login/View'
Item = require './pages/Item/View'


module.exports = router
  login:
    path: 'login'
    view: Login
  item:
    path: 'item/:itemId'
    view: Item
  app:
    path: '/'
    view: Index

