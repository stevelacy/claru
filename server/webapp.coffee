passport = require "./passport"
config = require "../config"
app = require "./express"
db = require "./db"

Item = db.models.Item

newNote = require "./functions/newNote"

app.get "/", (req, res) ->
  #return res.redirect "/login" unless req.user?
  if req.user?
    q = Item.find 
      user: req.user._id
      deleted: false
    q.sort 'date': -1
    q.exec (err, data) ->
      res.render "index", user: req.user, items: data
  else
    res.render "index"

app.get "/note/:note", (req, res) ->
  q = Item.find 
    _id: req.params.note
    user: req.user._id
    deleted: false
  q.exec (err, data) ->
    res.render "note", {user: req.user, note:data[0]}
    console.log data[0]

app.get "/logout", (req, res) ->
  req.logout()
  res.redirect "/"

app.get "/login", (req, res) ->
  return res.redirect "/" if req.user?
  res.render "login"


app.get "/auth/twitter", passport.authenticate "twitter"
app.get "/auth/twitter/callback",
  passport.authenticate "twitter",
    successRedirect:"/"
    falureRedirect:"/login"

app.post "/", (req, res) ->
  return res.send 401 unless req.user?
  newNote req.body.newNote, req.user._id, (err, data) ->
    console.log err
    console.log data
    res.redirect "/note/#{data._id}"

