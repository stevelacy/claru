{view, ChildView, DOM} = require 'fission'
NavBar = require '../../components/NavBar'

{div} = DOM

module.exports = view
  render: ->
    div className: 'application',
      NavBar back: !!~@getPath().indexOf 'item'
      ChildView()
