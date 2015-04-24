{component, DOM} = require 'fission'
{div} = DOM

module.exports = component
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
      div
        className: 'right'
        onClick: @props.onClick,
          @props.children
