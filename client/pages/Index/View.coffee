fission = require '../../app'

Model = require '../../models/Item'
NavBar = require '../../components/NavBar/NavBar'
ActionButton = require '../../components/ActionButton/ActionButton'
Modal = require '../../components/Modal/Modal'
ItemView = require './Item'

{div, button} = fission.React.DOM

module.exports = ->
  return window.location = '/login' unless window._user?
  fission.collectionView
    model: Model
    itemView: ItemView
    init: ->
      o =
        openModal: false
      return o
    newItem: ->
      m = new Model()
      m.save null,
        wait: true
        success: (m, res) ->
          fission.router.route "/item/#{res._id}"
        error: (m, res) ->
          console.log m, res

    render: ->
      div className: 'main index',
        NavBar home: true

        #Modal()
        ActionButton
          onClick: @newItem
          children: '+'
          style:
            fontSize: 50
            paddingLeft: 2
        div className: 'page',
          div className: 'items',
            @items
