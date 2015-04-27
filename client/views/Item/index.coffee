{modelView, DOM} = require 'fission'

Model = require '../../models/Item'
Toast = require '../../components/Toast'

{div, input, textarea, button} = DOM

module.exports = modelView
  displayName: 'NewItem'
  model: Model
  routeIdAttribute: 'itemId'
  statics:
    willTransitionTo: (transition) ->
      return transition.redirect 'login' unless window.token?
  init: ->
    title: ''
    message: ''
    disconnect: true

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

  handleTitle: (e) ->
    @setState title: e.target.value
    @model.set title: e.target.value
    data =
      title: @model.title
      message: @model.message
      id: @model._id
    window.socket.emit 'update', data

  handleContent: (e) ->
    @setState message: e.target.value
    @model.set message: e.target.value
    data =
      title: @model.title
      message: @model.message
      id: @model._id
    window.socket.emit 'update', data

  reconnect: ->
    window.location.reload()

  render: ->
    return null unless @model?
    div className: 'main item',
      div className: 'page',
        input
          type: 'text'
          value: @model.title
          onChange: @handleTitle
          placeholder: 'Title'
        textarea
          onChange: @handleContent
          value: @model.message
          placeholder: 'Message'
        if @state.disconnect
          Toast title: 'Error: disconnected',
            button onClick: @reconnect, 'Reconnect'
