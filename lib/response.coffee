contentDisposition = require('content-disposition')
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

  parseFile: (buffer, cb) ->
    if not buffer and Buffer.isBuffer(buffer)
      throw new Error('Requires buffer')
    if not cb
      throw new Error('Requires callback')
    disposition = contentDisposition.parse(@_response.headers['content-disposition'])
    filename = disposition.parameters.filename
    @_data = @data = {filename: filename, buffer: buffer}
    return cb(null, @)

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

          return cb({code: @code, message: @message}, @)

        else if @data?.response?.nodata
          error = @data.response.nodata

          if _.isArray(error)
            error = _.first(error)

          if error?.code
            @code = error.code
            if _.isArray(@code)
              @code = _.first(@code)

          if error?.message
            @message = error.message
            if _.isArray(@message)
              @message = _.first(@message)
          else
            @message = "Unknown Error"

          return cb(null,@)

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
          else if @data?.response?.success
            success = @data.response.success
            
            if _.isArray(success)
              success = _.first(success)

            if success?.code
              @code = success.code
              if _.isArray(@code)
                @code = _.first(@code)

            if success?.message
              @message = success.message
              if _.isArray(@message)
                @message = _.first(@message)
            else
              @message = "Unknown Success"
            
            @data = {'success' : {'code': @code, 'message': @message}}

          return cb(null, @)


module.exports = Response
