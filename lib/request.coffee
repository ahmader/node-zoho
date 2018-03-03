request = require('request')
url = require('url')
_ = require('underscore')

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
    options = _.pick(@_request,['method'])
    options.uri = url.format(@_request)
    chunks = new Buffer('')
    request(options, (error, response, body) =>
      if error
        cb(error,null)
      else
        if /text\/xml/.test(response.headers['content-type'])
          @response = new Response(response)
          @response.parseBody(body,cb)
        else
          @response = new Response(response)
          @response.parseFile(chunks,cb)
    ).on('response', (resp) ->
      resp.on('data', (chunk) ->
        chunks = Buffer.concat([chunks, chunk])
      )
    )



module.exports = Request
