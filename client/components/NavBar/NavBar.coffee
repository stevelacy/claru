fission = require '../../app'
logout = require '../../lib/logout'

{header, h1, li, a, div, span, p, button} = fission.React.DOM


View = fission.view
  init: ->
    o =
      openMenu: false
  goHome: ->
    window.history.back()
  toggleMenu: ->
    @setState openMenu: !@state.openMenu

  logout: ->
    logout()

  render: ->
    div className: 'navbar',
      div className: 'left',
        if !@props.home
          button
            className: 'button back'
            onClick: @goHome
            , '❬'
      div className: 'center',
        div className: 'title', fission.config.title

      div className: 'right',
        button
          onClick: @toggleMenu
          className: 'button settings', '⋮'

        # menu
        if @state.openMenu
          div
            className: 'menu-underlay'
            onClick: @toggleMenu,
            div className: 'menu',
              li onClick: @logout, 'logout'
module.exports = View
