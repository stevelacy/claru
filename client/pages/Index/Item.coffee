fission = require '../../app'

{div} = fission.React.DOM
Model = require '../../models/Item'
module.exports = fission.modelView
  model: Model
  link: ->
    fission.router.route "/item/#{@model._id}"
  render: ->
    div className: 'item',
      div
        className: 'title'
        onClick: @link,
          @model.title
