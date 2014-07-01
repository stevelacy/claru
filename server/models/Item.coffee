mongoose = require "mongoose"
Schema = mongoose.Schema

Item = new Schema
  title:
    type: String
  message:
    type: String
  user:
    type: Schema.Types.ObjectId
  deleted:
    type: Boolean
    default: false
  date:
    type: Number


Item.set "autoindex", false

module.exports = Item
