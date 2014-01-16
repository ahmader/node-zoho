url = require("url")
https = require("https")
_ = require("underscore")
async = require("async")
xml2js = require("xml2js")

helpers = require("./helpers")

class Zoho
  # defaults

  constructor: (options = {}) ->
    @authDefaults =
      host: "accounts.zoho.com"
      port: 443
      path: "/apiauthtoken/nb/create?SCOPE=ZohoCRM/crmapi"

    @crmApiDefaults =
      host: "crm.zoho.com"
      port: 443
      path:
        api: "crm"
        access: "private"
        encoding: "xml"
        resource: "Leads"
        method: "insertRecords"
      query:
        scope: "crmapi"
        authToken: undefined

    @xmlBuilderOpts =
      renderOpts:
        pretty: false
      xmldec:
        version: "1.0"
        encoding: "UTF-8"

    if options?.authToken
      @crmApiDefaults.query.authToken = options?.authToken

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


  insertRecords: (resource, records, cb) ->
    xmlObj = @_buildRecordsXmlObj(records)

    @xmlBuilderOpts.rootName = resource
    xmlBuilder = new xml2js.Builder(@xmlBuilderOpts)

    xmlString = xmlBuilder.buildObject(xmlObj)

    insertUrl = @_buildQueryUrl({
      path:
        resource: resource
        method: "insertRecords"
      query:
        newFormat: 1
        xmlData: xmlString
      method: "POST"
    })

    helpers.request(insertUrl, (err, zohoRes) ->
      xml2js.parseString(zohoRes, (err, xml) ->
        if err
          cb(err, null)
        else
          cb(null, xml)
      )
    )

  getRecords: (resource, params, cb) ->
    ###
    insertUrl = @_buildQueryUrl({
      path:
        resource: resource
        method: "insertRecords"
      query:
        selectColumns: "all"
        searchCondition:
        version: 2
    })
    ###



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
