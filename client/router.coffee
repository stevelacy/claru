{router} = require 'fission'

Application = require './pages/Application'
Index = require './pages/Index'
Login = require './pages/Login'
Item = require './pages/Item'


module.exports = router
  app:
    path: '/'
    view: Application
    defaultChild:
      view: Index
    children:
      login:
        path: 'login'
        view: Login
      item:
        path: 'item/:itemId'
        view: Item
