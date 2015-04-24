{collectionView, DOM} = require 'fission'

Model = require '../../models/Item'
NavBar = require '../../components/NavBar'
ActionButton = require '../../components/ActionButton/ActionButton'
Toast = require '../../components/Toast/Toast'
ItemView = require './Item'

{div, button} = DOM

module.exports = collectionView
  displayName: 'Index'
  statics:
    willTransitionTo: (transition) ->
      return transition.redirect 'login' unless window.token?
  collection:
    model: Model
  itemView: ItemView
  init: ->
    disconnect: false
  newItem: ->
    m = new Model()
    m.save null,
      wait: true
      success: (m, res) ->
        window.location = "/item/#{res._id}"
  reconnect: ->
    window.location = '/'

  mounted: ->
    window.socket.on 'disconnect', =>
      if @isMounted()
        @setState disconnect: true
    window.socket.on 'connect', =>
      if @isMounted()
        @setState disconnect: false
    if window.socket.connected
      @setState disconnect: false

  render: ->
    div className: 'main index',
      # NavBar home: true

      ActionButton
        onClick: @newItem
        children: '+'
        style:
          fontSize: 35
          paddingLeft: 2
      div className: 'page',
        div className: 'items',
          @items
      if @state.disconnect
        Toast title: 'Error: disconnected',
          button onClick: @reconnect, 'Reconnect'
