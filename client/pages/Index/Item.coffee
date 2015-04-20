{modelView, DOM} = require 'fission'

Model = require '../../models/Item'
{div, button} = DOM

module.exports = modelView
  model: Model
  link: ->
    fission.router.route "/item/#{@model._id}"
  destroy: ->
    @model.destroy()

  render: ->
    div className: 'item',
      div
        className: 'title'
        onClick: @link,
          @model.title
      button
        className: 'destroy'
        onClick: @destroy,
          'x'
