{component, DOM} = require 'fission'

{div, button} = DOM


module.exports = component
  close: ->
    setTimeout @props.onClose, 10
  render: ->
    div className: 'modal',
      button
        className: 'button light close'
        onClick: @close
        , 'X'

      if @props.content?
        @props.content()
