{router} = require 'fission'

Application = require './pages/Application'
Index = require './pages/Index/View'
Login = require './pages/Login/View'
Item = require './pages/Item/View'


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
