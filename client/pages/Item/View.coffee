{modelView, DOM} = require 'fission'

Model = require '../../models/Item'
NavBar = require '../../components/NavBar/NavBar'
Toast = require '../../components/Toast/Toast'

{div, input, textarea, button} = DOM

module.exports = modelView
  model: Model
  init: ->
    o =
      title: ''
      message: ''
      disconnect: true
    return o
  mounted: ->
    fission.socket.on 'disconnect', =>
      if @isMounted()
        @setState disconnect: true
    fission.socket.on 'connect', =>
      if @isMounted()
        @setState disconnect: false
    if fission.socket.connected
      @setState disconnect: false

    fission.socket.on 'update', ({data}) =>
      @model.message = data.message
      @model.title = data.title

  handleTitle: (e) ->
    @setState title: e.target.value
    @model.set title: e.target.value
    data =
      title: @model.title
      message: @model.message
      id: @model._id
    fission.socket.emit 'update', data

  handleContent: (e) ->
    @setState message: e.target.value
    @model.set message: e.target.value
    data =
      title: @model.title
      message: @model.message
      id: @model._id
    fission.socket.emit 'update', data

  reconnect: ->
    fission.router.route "/item/#{@model._id}"

  render: ->
    div className: 'main item',
      NavBar()
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
