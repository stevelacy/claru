{component, DOM} = require 'fission'

{div, button} = DOM
module.exports = component
  render: ->
    style = {}
    if @props.style?
      style = @props.style

    div
      onClick: @props.onClick
      className: 'actionbutton',
      div
        className: 'icon'
        style: style
      , @props.children
