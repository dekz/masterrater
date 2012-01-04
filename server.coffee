async = require 'async'
express = require 'express'

app = express.createServer()

app.configure 'development', ->
  app.use express.static __dirname + '/public'
  app.use express.bodyParser()

app.get '/:website/:uuid/info', (req, res) ->
  res.send "get redis info for #{req.params.website} and #{req.params.uuid}"

app.post '/:website/:uuid/rate', (req, res) ->
  res.send "write to redis info for #{req.params.website} and #{req.params.uuid}"


app.listen 3000

