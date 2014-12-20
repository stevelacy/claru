fission = require '../../app'

Model = require '../../models/Item'
NavBar = require '../../components/NavBar/NavBar'

{div, input, textarea} = fission.React.DOM

module.exports = fission.modelView
  model: Model
  init: ->
    o =
      title: ''
      content: ''
    return o

  handleTitle: (e) ->
    @setState title: e.target.value
    @model.set title: e.target.value
    data =
      title: e.target.value
      id: @model._id
    fission.socket.emit 'title', data

  handleContent: (e) ->
    @setState content: e.target.value
    @model.set content: e.target.value
    data =
      content: e.target.value
      id: @model._id
    fission.socket.emit 'content', data

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
          value: @model.content
          placeholder: 'Message'
