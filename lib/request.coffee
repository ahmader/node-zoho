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
    options = _.pick(@_request,['method', 'form'])
    options.uri = url.format(@_request)
    request(options, (error, response, body) =>
      if error
        cb(error,null)
      else
        @response = new Response(response)
        @response.parseBody(body,cb)
    )



module.exports = Request
