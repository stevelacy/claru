{modelView, DOM} = require 'fission'

Model = require '../../models/Item'
{div, button} = DOM

module.exports = modelView
  displayName: 'ItemView'
  model: Model
  link: ->
    @transitionTo "/item/#{@model._id}"
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
          '×'
