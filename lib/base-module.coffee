_ = require('underscore')

class BaseModule
  name: "BaseModule"
  format: "xml"
  scope: "private"

  constructor: (@product) ->
    if not @product
      throw new Error('Requires product')
    return

  getUrlParts: ->
    return [ @scope, @format, @name ]

  buildUrl: (query={}, path=[], options={}) ->
    method = 'POST'
    if options?.method
      method = options.method.toUpperCase()
    url = @product.getBaseUrl()
    url.method = method
    url.path = url.path.concat(@getUrlParts())
    url.path = url.path.concat(path)
    url.pathname = "/" + url.path.join("/")
    _.extend(url.query, query)
    return url

module.exports = BaseModule
