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
        style:
          height: if @model.message?.length > 10 then 110 else 60
        onClick: @link,
          @model.title
      div
        className: 'message'
        onClick: @link,
          @model.message
          div className: 'fade'
      button
        className: 'destroy'
        onClick: @destroy,
          '×'
