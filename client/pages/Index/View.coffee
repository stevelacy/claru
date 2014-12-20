fission = require '../../app'

Model = require '../../models/Item'
NavBar = require '../../components/NavBar/NavBar'
ActionButton = require '../../components/ActionButton/ActionButton'
Toast = require '../../components/Toast/Toast'
ItemView = require './Item'

{div, button} = fission.React.DOM

module.exports = ->
  return fission.router.route '/login' unless window._user?
  fission.collectionView
    model: Model
    itemView: ItemView
    init: ->
      o =
        disconnect: false
        openModal: false
      return o
    newItem: ->
      m = new Model()
      m.save null,
        wait: true
        success: (m, res) ->
          fission.router.route "/item/#{res._id}"
    reconnect: ->
      fission.router.route '/'

    mounted: ->
      fission.socket.on 'disconnect', =>
        if @isMounted()
          @setState disconnect: true
      fission.socket.on 'connect', =>
        if @isMounted()
          @setState disconnect: false
      if fission.socket.connected
        @setState disconnect: false

    render: ->
      div className: 'main index',
        NavBar home: true

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
