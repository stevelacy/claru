fission = require '../../app'

{div, button} = fission.React.DOM
module.exports = fission.view
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
