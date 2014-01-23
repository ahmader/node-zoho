https = require('https')
url = require('url')

Response = require('./response')

class Request
  response: null

  constructor: (@module,@_request) ->
    if not @module
      throw new Error('Requires Zoho Module')

    if not @_request
      throw new Error('Requires request')
    return

  request: (cb) ->
    requestUrl = url.parse(url.format(@_request))

    req = https.request(requestUrl, (response) ->
      @response = new Response(response, cb)
      response.on('data', @response.handleChunk.bind(@response))
      response.on("end", @response.handleEnd.bind(@response))
    )
    req.end()

    req.on('error', (err) ->
      return cb(err, null)
    )



module.exports = Request
