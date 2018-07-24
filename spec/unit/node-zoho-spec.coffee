xml2js = require("xml2js")
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

    it "sets @authToken", ->
      expect(zohoApi.authToken).toEqual(options.authToken)

  describe "instance", ->

    describe 'execute', ->
      _module = product = undefined

      beforeEach ->
        _module = { insertRecords: () ->}
        product = { getModule: () -> return _module }
        spyOn(zohoApi,'getProduct').andReturn(product)
        spyOn(_module,'insertRecords')

      it 'calls through', ->
        myCB = () ->
          return
        zohoApi.execute('crm','Leads','insertRecords',[], myCB)
        expect(_module.insertRecords).toHaveBeenCalledWith([],myCB)

    describe 'getProduct', ->
      it('returns instance product', ->
      )

      it('has product initialized with zoho instance', ->
      )

      it('throws error if product not found', ->
      )

    xdescribe "generateAuthToken", ->
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

    describe "test Zoho region", ->
      it "has default region", ->
        expect(zohoApi.region).toEqual('com')

      it "has specified region", ->
        options.region = 'eu'
        zohoApi = new zoho(options)
        expect(zohoApi.region).toEqual('eu')

    describe "test Zoho sandbox mode", ->
      it "has default disabled sandbox mode", ->
        expect(zohoApi.isSandbox).toEqual(false)

      it "has enabled sandbox mode", ->
        tempOptions = Object.assign({isSandbox: true}, options)
        tempZohoApi = new zoho(tempOptions)
        expect(tempZohoApi.isSandbox).toEqual(true)
