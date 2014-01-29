url = require("url")
https = require("https")
_ = require("underscore")
async = require("async")
xml2js = require("xml2js")

class Zoho
  authToken: null

  constructor: (options = {}) ->
    @authDefaults =
      host: "accounts.zoho.com"
      port: 443
      path: "/apiauthtoken/nb/create?SCOPE=ZohoCRM/crmapi"

    if options?.authToken
      @authToken = options?.authToken

    return @

  getProduct: (productName) ->
    Crm = require './products/crm'
    return new Crm(@)

  execute: (product, module, call) ->
    args = Array.prototype.slice.call(arguments)
    productInstance = @getProduct(product)
    moduleInstance = productInstance.getModule(module)
    moduleInstance[call].apply(moduleInstance,args.slice(3))

module.exports = Zoho
