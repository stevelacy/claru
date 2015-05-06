{modelView, DOM, Link} = require 'fission'

Model = require '../../models/Item'
Toast = require '../../components/Toast'

{div, input, textarea, button} = DOM

module.exports = modelView
  displayName: 'Search'
  model: Model
  routeIdAttribute: 'itemId'
  statics:
    willTransitionTo: (transition) ->
      return transition.redirect 'login' unless window.token?
  init: ->
    term: ''
    items: []

  mounted: ->
    window.socket.on 'disconnect', =>
      if @isMounted()
        @setState disconnect: true
    window.socket.on 'connect', =>
      if @isMounted()
        @setState disconnect: false
    if window.socket.connected
      @setState disconnect: false

    window.socket.on 'update', ({data}) =>
      @model.message = data.message
      @model.title = data.title

    window.socket.on 'search', (data) =>
      @setState items: data

  search: (e) ->
    @setState term: e.target.value
    window.socket.emit 'search', term: @state.term

  reconnect: ->
    window.location.reload()

  render: ->
    return null unless @model?
    div className: 'main search',
      div className: 'page',
        input
          type: 'text'
          value: @term
          onChange: @search
          placeholder: 'Search'

        div className: 'items',
          @state.items.map (item) ->
            div className: 'item',
              div
                className: 'title'
                style:
                  height: if item.message?.length > 10 then 110 else 60
                Link
                  to: "/item/#{item._id}"
                  item.title
              Link
                className: 'message'
                to: "/item/#{item._id}",
                  item.message
                  div className: 'fade'

        if @state.disconnect
          Toast title: 'Error: disconnected',
            button onClick: @reconnect, 'Reconnect'
