fission = require '../../app'

{header, h1, img, a, div, span, p, button} = fission.React.DOM


View = fission.view
  goHome: ->
    window.history.back()
  render: ->
    div className: 'navbar',
      div className: 'left',
        if !@props.home
          button
            className: 'button back'
            onClick: @goHome
            , '❬'
      div className: 'center',
        div className: 'title', 'Title'
      div className: 'right',
        button className: 'button settings', '⋮'
module.exports = View
