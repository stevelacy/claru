{router} = require 'fission'

Application = require './views/Application'
Index = require './views/Index'
Login = require './views/Login'
Item = require './views/Item'

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
