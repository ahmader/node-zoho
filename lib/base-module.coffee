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
    url = @product.getBaseUrl()
    url.method = 'POST'
    url.path = url.path.concat(@getUrlParts())
    url.path = url.path.concat(path)
    url.pathname = "/" + url.path.join("/")
    _.extend(url.query, query)
    return url

module.exports = BaseModule
