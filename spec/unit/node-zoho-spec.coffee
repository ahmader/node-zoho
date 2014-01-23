xml2js = require("xml2js")
help = require("../../lib/helpers")
zoho = require("../../lib/node-zoho")

zohoApi = undefined

describe "node-zoho", ->

  results = errors = done = undefined

  options =
    authToken: "TESTTOKEN"

  lead =
    "Lead Source" : "Site Registration"
    "First Name"  : "Hannah"
    "Last Name"   : "Smith"
    Email: "belfordz66@gmail.com"

  beforeEach ->
    zohoApi = new zoho(options)
    done = false
    results = errors = undefined

  describe "constructor", ->

    it "exists", ->
      expect(typeof zoho).toBe("function")

    it "sets @crmApiDefaults.query.authToken", ->
      expect(zohoApi.crmApiDefaults.query.authToken).toEqual(options.authToken)

  describe "instance", ->

    describe "has a public method", ->

      describe "generateAuthToken", ->
        beforeEach ->
          spyOn(help, "request").andCallFake( ->
            cb = arguments[arguments.length-1]

            if typeof cb != "function"
              throw new Error("mockModelCb: the cb called is not a function.")

            setImmediate(cb, null, "AUTHTOKEN:123\n")
          )

        it "makes a call to help.request with proper data", ->
          runs ->
            zohoApi.generateAuthToken("cool@picatic.com", "seriously, cool", (err, res) ->
              results = res
              errors = err
              done = true
            )
          waitsFor -> return done
          runs ->
            expect(help.request).toHaveBeenCalledWith({ host : 'accounts.zoho.com', port : 443, path : '/apiauthtoken/nb/create?SCOPE=ZohoCRM/crmapi&EMAIL_ID=cool@picatic.com&PASSWORD=seriously, cool', method : 'POST' }, jasmine.any(Function))


      describe "insertRecord", ->
        xmlBuilder = mockBuilder = undefined

        beforeEach ->
          spyOn(zohoApi, "_buildRecordsXmlObj").andReturn({})

          mockBuilder = {
            buildObject: () ->
              return "wicked"
          }
          spyOn(xml2js, "Builder").andReturn(mockBuilder)
          xmlBuilder = new xml2js.Builder()


          spyOn(xmlBuilder, "buildObject").andReturn("")

          spyOn(zohoApi, "_buildQueryUrl").andReturn("b")

          spyOn(help, "request").andCallFake( ->
            cb = arguments[arguments.length-1]

            if typeof cb != "function"
              throw new Error("mockModelCb: the cb called is not a function.")

            setImmediate(cb, null, "All Good")
          )

          spyOn(xml2js, "parseString").andCallFake( ->
            cb = arguments[arguments.length-1]

            if typeof cb != "function"
              throw new Error("mockModelCb: the cb called is not a function.")

            setImmediate(cb, null, "All Good")
          )

        it "builds an object to convert to xml", ->
          runs ->
            zohoApi.insertRecords("a", "b", (err, res) ->
              results = res
              errors = err
              done = true
            )
          waitsFor ->
            return done
          runs ->
            expect(zohoApi._buildRecordsXmlObj).toHaveBeenCalled()

        it "builds the xmlString", ->
          runs ->
            zohoApi.insertRecords("a", "b", (err, res) ->
              results = res
              errors = err
              done = true
            )
          waitsFor ->
            return done
          runs ->
            expect(xml2js.Builder).toHaveBeenCalled()
            expect(mockBuilder.buildObject).toHaveBeenCalled()

        it "builds the url for the request", ->
          runs ->
            zohoApi.insertRecords("a", "b", (err, res) ->
              results = res
              errors = err
              done = true
            )
          waitsFor ->
            return done
          runs ->
            expect(zohoApi._buildQueryUrl).toHaveBeenCalled()

        it "sends the request", ->
          runs ->
            zohoApi.insertRecords("a", "b", (err, res) ->
              results = res
              errors = err
              done = true
            )
          waitsFor ->
            return done
          runs ->
            expect(help.request).toHaveBeenCalled()

    xdescribe "has a private method", ->

      describe "_buildQueryUrl", ->

      describe "_buildRecordsXmlObj", ->


