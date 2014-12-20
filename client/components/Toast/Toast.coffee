fission = require '../../app'
{div} = fission.React.DOM

module.exports = fission.view
  init: ->
    opacity: 1
  mounted: ->
    #setTimeout =>
    #  @setState opacity: 0
    #, 2000
  render: ->
    div
      #style: opacity: @state.opacity
      className: 'toast',
      div className: 'title', @props.title
