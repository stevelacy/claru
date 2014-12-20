fission = require '../../app'

Model = require '../../models/Item'
{div, button} = fission.React.DOM

module.exports = fission.modelView
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
