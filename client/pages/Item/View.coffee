fission = require '../../app'

Model = require '../../models/Item'
NavBar = require '../../components/NavBar/NavBar'

{div, input, textarea} = fission.React.DOM

module.exports = fission.modelView
  model: Model
  init: ->
    o =
      title: ''
      message: ''
    return o

  handleTitle: (e) ->
    @setState title: e.target.value
    @model.set title: e.target.value
    data =
      title: e.target.value
      id: @model._id
    fission.socket.emit 'title', data

  handleContent: (e) ->
    @setState message: e.target.value
    @model.set message: e.target.value
    data =
      message: e.target.value
      id: @model._id
    fission.socket.emit 'message', data

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
