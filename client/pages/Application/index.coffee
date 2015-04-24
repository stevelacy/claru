{view, ChildView, DOM} = require 'fission'
NavBar = require '../../components/NavBar'

{div} = DOM

module.exports = view
  displayName: 'Application'
  render: ->
    div className: 'application',
      if !~@getPath().indexOf 'login'
        NavBar back: ~@getPath().indexOf 'item'
      ChildView()
