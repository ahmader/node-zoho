xml2js = require("xml2js")
_ = require('underscore')

class Response

  # instance values
  message:   null
  type:      null
  data:      null
  code:      null
  _response: null
  _data:     null

  # constuctor
  constructor: (@_response) ->
    if @_response is undefined
      throw new Error('Requires response')
    return

  isError: () ->
    if @code != null
      return true
    return false

  parseBody: (body, cb) ->
    if not body
      throw new Error('Requires body')
    if not cb
      throw new Error('Requires callback')

    @_data = body
    xml2js.parseString @_data, (err, data) =>
      if err
        return cb(err, null)
      else
        @data = data
        if @data?.response?.error
          error = @data.response.error

          if _.isArray(error)
            error = _.first(error)

          if error?.code
            @code = error.code

          if error?.message
            @message = error.message
          else
            @message = "Unknown Error"

          return cb(new Error(@message),@)

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
              return cb(new Error("Multi result arrays not handled"), @)

          return cb(null, @)


module.exports = Response
