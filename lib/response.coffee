xml2js = require("xml2js")
_ = require('underscore')

class Response

  # instance values
  message: null
  type: null
  data: null
  code: null
  _response: null
  _data: ""
  _cb: null

  # constuctor
  constructor: (@_response, @_cb) ->
    return

  handleChunk: (chunk) ->
    if chunk?.status == "error"
      @_cb(new Error("Recieved error: #{chunk}"), null)
    else
      @_data += chunk

  handleEnd: () ->
    if @_response.statusCode isnt 200
      @_handleError()
    else
      @_parseResponse()

  isError: () ->
    if @code != null
      return true
    return false

  _handleError: ->
    @_cb(new Error("Bad Status code: #{res.statusCode}"), null)

  _parseResponse: ->
    xml2js.parseString(@_data, (err, data) =>
      if err
        @_cb(err, null)
      else
        @data = data
        if @data?.response?.error
          error = @data.response.error
          if @error?.code then @code = @error.code
          if @error?.message then @message = @error.message
          @_cb(new Error(@message),@)
        else
          if @data?.response?.result
            if _.isArray(@data?.response?.result) and @data?.response?.result.length == 1
              record = _.first(@data?.response?.result)
              if record?.message
                @message = record.message

              if record?.recorddetail
                @data = record.recorddetail
              else
                @data = record

            else
              throw new Error("Multi result arrays not handled")

          @_cb(null, @)
    )


module.exports = Response
