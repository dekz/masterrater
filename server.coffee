async = require 'async'
express = require 'express'
_redis = require 'redis'
redis = _redis.createClient()

app = express.createServer()

app.configure 'development', ->
  app.use express.static __dirname + '/public'
  app.use express.bodyParser()


whitelist =
  'github.com': { parse: (info, cb) -> cb(undefined,info) }
  'asos.com': { parse: (info, cb) -> cb(undefined,info) }


app.get '/:website/:uuid/info', (req, res) ->
  _site = whitelist[req.params.website]
  if _site?
    _site.parse req.params.uuid, (err, data) ->
      if err?
        res.send 'Error parsing'
      else
        redis.smembers req.params.website + data, (err, result) ->
          if err?
            res.send { err: { code: err } }
          else
            res.send { resp: { data: result } }
  else
    res.send 'Error'


app.post '/:website/:uuid/rate', (req, res) ->
  _site = whitelist[req.params.website]
  if _site?
    _site.parse req.params.uuid, (err, data) ->
      if err?
        res.send 'Error parsing'
      else
        # Replace with full JSON of date, comment, rating, etc
        comment = escape req.body.comment
        redis.sadd req.params.website + data, comment, (err, result) ->
          if err?
            res.send { err: { code: err } }
          else
            res.send { resp: { data: result } }
  else
    res.send 'Error'


app.listen 3000

