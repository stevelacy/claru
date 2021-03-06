{component, DOM, Link} = require 'fission'
logout = require '../../lib/logout'

{li, div, img, button} = DOM

module.exports = component
  init: ->
    o =
      openMenu: false

  goBack: ->
    window.history.back()

  toggleMenu: ->
    @setState openMenu: !@state.openMenu

  reload: ->
    window.location.reload()

  logout: ->
    logout()

  render: ->
    div className: 'navbar',
      div className: 'left',
        if @props.back
          button
            className: 'button back'
            onClick: @goBack
            , '❬'
      div className: 'center',
        div
          className: 'title'
          onClick: @reload
          window._config.title

      div className: 'right',
        button
          onClick: @toggleMenu
          className: 'button settings', '⋮'
        div className: 'icons',
          Link
            to: 'search',
            img
              src: '/img/search.png'

        # menu
        if @state.openMenu
          div
            className: 'menu-underlay'
            onClick: @toggleMenu,
            div className: 'menu',
              li onClick: @logout, 'logout'
