app = require './'
config = require '../../config'
{join} = require 'path'
idxFile = join config.pubdir, 'index.html'

app.get "/config.js", (req, res) ->
  src = "window._config = {"
  src += "  name: '#{config.name}',"
  src += "  title: '#{config.title}',"
  src += "  url: '#{config.url}'"
  src += "};"

  res.set "Content-Type", "application/javascript"
  res.status 200
    .send src


# serve spa
app.get '/*', (req, res) ->
  res.sendFile idxFile

module.exports = app
