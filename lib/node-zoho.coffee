url = require("url")
https = require("https")
_ = require("underscore")
async = require("async")
xml2js = require("xml2js")

helpers = require("./helpers")

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

  generateAuthToken: (email, password, cb) ->
    if email is undefined or typeof email isnt "string"
      return cb(new Error("An email string must be provided"))
    else if password is undefined or typeof email isnt "string"
      return cb(new Error("A password string must be provided"))
    else if typeof cb isnt "function"
      throw new Error("the last argument to generateAuthToken must be a function")

    flow = []

    authUrl = _.clone(@authDefaults)
    authUrl.path = "#{authUrl.path}&EMAIL_ID=#{email}&PASSWORD=#{password}"
    authUrl.method = "POST"

    flow.push((_cb) -> helpers.request(authUrl, _cb))

    flow.push((response, _cb) ->
      ind = response.indexOf("AUTHTOKEN")

      if ind is -1
        _cb(new Error("Auth token generation failed"), null)
      else
        # FML... Unstructured data FTL
        endInd = response.indexOf("\n", ind)
        _cb(null, response.substring(ind+10, endInd))
    )

    async.waterfall(flow, (err, results) =>
      if err
        return cb(err, null)
      else
        @authToken = @crmApiDefaults.query.authToken = results
        return cb(null, results)
    )

  getProduct: (productName) ->
    Crm = require './products/crm'
    return new Crm(@)

  execute: (product, module, call) ->
    args = Array.prototype.slice.call(arguments)
    productInstance = @getProduct(product)
    moduleInstance = productInstance.getModule(module)
    moduleInstance[call].apply(moduleInstance,args.slice(3))


  _buildQueryUrl: (urlObj) ->
    path = _.defaults(@crmApiDefaults.path, urlObj.path)
    query = _.defaults(@crmApiDefaults.query, urlObj.query)

    # and the winner for worst line of code ever is......
    query = "?authtoken=#{query.authToken}&scope=#{query.scope}&xmlData=#{encodeURI(query.xmlData)}&newFormat=1"

    urlObj = _.defaults(@crmApiDefaults, urlObj)

    path = "/#{path.api}/#{path.access}/#{path.encoding}/#{path.resource}/#{path.method}#{query}"
    delete urlObj.query
    urlObj.path = path

    return urlObj


  _buildRecordsXmlObj: (records) ->
    if not _.isArray(records)
      records = [records]

    xmlObj = {
      row: []
    }

    for record, i in records
      xmlRowObj =
        "$":
          no: i
        FL: []

      for key, val of record
        xmlRowObj.FL.push({
          "$":
            val: key
          "_": val
        })

      xmlObj.row.push(xmlRowObj)

    return xmlObj


module.exports = Zoho
