request = require 'superagent'
{view, DOM} = require 'fission'

{div, h1, button, a, img, br, form, input} = DOM

module.exports = view
  displayName: 'Login'
  statics:
    willTransitionTo: (transition) ->
      return transition.redirect '/' if window.token?
  init: ->
    email: ''
    password: ''
    status: ''

  updateEmail: (e) ->
    @setState email: e.target.value

  updatePassword: (e) ->
    @setState password: e.target.value

  login: (e) ->
    e.preventDefault()
    data =
      email: @state.email
      password: @state.password
    request.post "#{window._config.url}/login", data, (err, res) =>

      if res?.status is 200
        window.localStorage.setItem 'token', res.body.token
        window.location = '/'

      else
        @setState status: res.body.message
        setTimeout =>
          @setState status: ''
        , 2000

  mounted: ->
    @refs.email.getDOMNode().focus()

  render: ->
    div className: 'main login',
      div className: 'page',
        div className: 'box',

          div className: 'logo white', window._config.name
          form
            method: 'post'
            onSubmit: @login,
            input
              type: 'email'
              name: 'email'
              ref: 'email'
              placeholder: 'Email'
              value: @state.email
              onChange: @updateEmail
            input
              type: 'password'
              name: 'password'
              value: @state.password
              onChange: @updatePassword
              placeholder: '****'

            div className: 'spacer-50'
            input
              type: 'submit'
              value: 'LOGIN'
              className: 'button blue large wide center'
              style: cursor: 'pointer'
            div className: 'status',
              @state.status
