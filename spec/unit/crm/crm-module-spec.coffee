_ = require('underscore')

CrmModule = require('../../../lib/products/crm/crm-module')
BaseModule = require('../../../lib/base-module')

Request = require('../../../lib/request')
Response = require('../../../lib/response')

describe 'crm module', ->

  crmModule = null
  product = null
  record = null

  beforeEach ->
    product = {}
    record = {
      "Lead Source": "Unit Test",
      "First Name": "Test",
      "Last Name": "Testerson",
      "Email": "test@testerson.com"
    }
    crmModule = new CrmModule(product)

  describe 'build', ->
    beforeEach ->
      spyOn(crmModule,'buildRecords').andReturn([{$:{no:1},FL:[{_:'TEST'},{_:'TEST2'}]}])

    it 'accepts array', ->

    it 'returns string', ->

    it 'calls buildRecords', ->
      crmModule.build([record])
      expect(crmModule.buildRecords).toHaveBeenCalledWith([record])

    it 'returns expected string', ->
      result = crmModule.build([record])
      expect(result).toMatch(/\?xml/)
      expect(result).toMatch('<row no="1"')
      expect(result).toMatch('<FL>TEST</FL>')

  describe 'buildRecord', ->

    it "accepts Object", ->
      expect(() -> crmModule.buildRecord("asdf")).toThrow('Object required')

    it "returns Array", ->
      result = crmModule.buildRecord({})
      expect(_.isArray(result)).toBeTruthy()

    it "key in to $.val", ->
      result = crmModule.buildRecord({test:'value'})
      expect(result.length).toEqual(1)
      expect(result[0].$.val).toEqual('test')

    it "value to be in _", ->
      result = crmModule.buildRecord({test:'value'})
      expect(result.length).toEqual(1)
      expect(result[0]._).toEqual('value')

    it 'supports nested records', ->
      result = crmModule.build [
        "Subject": "Test",
        "Account Name": "phone account11 9pm",
        "Product Details": [
          "Product Id": "269840000000136287",
          "Product Name": "prd1"
        ]
      ]
      expect(result).toMatch(/\?xml/)
      expect(result).toContain('<row no="1"')
      expect(result).toContain('<FL val="Subject">Test</FL><FL val="Account Name">phone account11 9pm</FL>')
      expect(result).toContain('<FL val="Product Details"><product no="1">')
      expect(result).toContain('<FL val="Product Id">269840000000136287</FL><FL val="Product Name">prd1</FL>')


  describe 'buildRecords', ->
    record_set = undefined

    beforeEach ->
      record_set = [ record ]

    it "requires array", ->
      expect( () -> crmModule.buildRecords({})).toThrow('Requires array of records')

    it "returns array", ->

      result = crmModule.buildRecords(record_set)
      expect(_.isArray(result)).toBeTruthy()

    it "calls buildRecord", ->
      spyOn(crmModule,'buildRecord').andReturn([])
      result = crmModule.buildRecords(record_set)
      expect(crmModule.buildRecord).toHaveBeenCalledWith(record)

    it "sets row no", ->
      result = crmModule.buildRecords(record_set)
      expect(result[0].$.no).toBe(1)

    it "sets record on FL", ->
      _record = [ 'a','record' ]
      spyOn(crmModule,'buildRecord').andReturn(_record)
      result = crmModule.buildRecords(record_set)
      expect(result[0].FL).toEqual(_record)

  describe 'processRecord', ->

    describe "single FL response", ->
      compiled_record = undefined

      beforeEach ->
        compiled_record = crmModule.buildRecord(record)

      it 'handles FL array', ->
        compiled_record = { FL: [ {$:{val:"test"},_:"value"}]}
        processed = crmModule.processRecord(compiled_record)
        expect(processed).toEqual({test:"value"})

      it 'handles complicated response', ->
        compiled_record = [{"FL":[{"_":"953419000000673233","$":{"val":"Id"}},{"_":"2014-01-23 14:55:23","$":{"val":"Created Time"}},{"_":"2014-01-23 14:55:23","$":{"val":"Modified Time"}},{"_":"Parmar","$":{"val":"Created By"}},{"_":"Parmar","$":{"val":"Modified By"}}]}]
        processed = crmModule.processRecord(compiled_record)
        expect(processed).toEqual({ Id : '953419000000673233', "Created Time" : '2014-01-23 14:55:23', "Modified Time" : '2014-01-23 14:55:23', "Created By" : 'Parmar', "Modified By" : 'Parmar' })


    describe "param labeled row", ->

      it "returns single object with key and value", ->
        expect(crmModule.processRecord({_:"value",$:{param:"key"}})).toEqual({key:"value"})

    describe "val labeled row", ->

      it "returns single object with key and value", ->
        expect(crmModule.processRecord({_:"value",$:{val:"key"}})).toEqual({key:"value"})

    describe "simple success", ->
      # <success><Contact param="id">1071983000000078003</Contact></success>
      single_response = {"success":{"Contact":[{"_":"1071983000000075005","$":{"param":"id"}}]}}
      multiple_response = {"success":{"Contact":[{"_":"1071983000000075009","$":{"param":"id"}}],
      "Potential":[{"_":"1071983000000075011","$":{"param":"id"}}]}}

      it "single response", ->
        processed = crmModule.processRecord(single_response)
        expect(processed).toEqual({Contact: {id:'1071983000000075005'}})

      it "multiple response", ->
        processed = crmModule.processRecord(multiple_response)
        expect(processed).toEqual({Contact: {id:'1071983000000075009'},Potential: {id:'1071983000000075011'}})

  describe 'insertRecords', ->
    response = next = undefined

    beforeEach ->
      spyOn(crmModule,'build').andReturn('<?xml version="1.0" encoding="UTF-8"?><crmModule/>')
      response = new Response({})
      next = false
      spyOn(Request.prototype,'request').andCallFake( (cb) ->
        setImmediate(cb,null,response)
      )
      spyOn(crmModule,'buildUrl').andReturn({})
      spyOn(crmModule,'processRecord').andReturn({})

    it 'requires array', ->
      expect( () -> crmModule.insertRecords(record,() -> ) ).toThrow('Requires array of records')

    it 'requires at least one record', ->
      expect( () -> crmModule.insertRecords([],() -> ) ).toThrow('Requires as least one record')

    it 'calls buildRecords', ->
      crmModule.insertRecords([record],undefined)
      expect(crmModule.build).toHaveBeenCalledWith([record])

    it 'builds Url', ->
      crmModule.insertRecords([record],undefined)
      expect(crmModule.buildUrl).toHaveBeenCalledWith(
        {newFormat:1,xmlData:'<?xml version="1.0" encoding="UTF-8"?><crmModule/>'},
        ['insertRecords'],
        {method:'POST'}
      )

    it 'calls callback with response', ->
      r = undefined
      runs ->
        crmModule.insertRecords([record], (err,_r) ->
          r = _r
          next = true
        )
      waitsFor ->
        return next
      runs ->
        expect(r).toEqual(response)

    it 'calls callback with options with response', ->
      r = undefined
      runs ->
        crmModule.insertRecords([record], {}, (err,_r) ->
          r = _r
          next = true
        )
      waitsFor ->
        return next
      runs ->
        expect(r).toEqual(response)

  describe 'getRecordById', ->
    next = response = undefined

    beforeEach ->
      next = false
      response = new Response({})
      spyOn(crmModule,'buildUrl').andReturn({})
      spyOn(Request.prototype,'request').andCallFake( (cb) ->
        setImmediate(cb,null,response)
      )

    it 'requires record id param', ->
      expect( () -> crmModule.getRecordById() ).toThrow('Requires an Id to fetch')

    it 'build Url', ->
      crmModule.getRecordById('1234567890123456',undefined)
      expect(crmModule.buildUrl).toHaveBeenCalledWith(
        {id:'1234567890123456', newFormat:1},
        ['getRecordById'],
        {method:'GET'}
      )

    it 'calls callback with response', ->
      r = undefined
      runs ->
        crmModule.getRecordById('1234567890123456', (err,_r) ->
          r = _r
          next = true
        )
      waitsFor ->
        return next
      runs ->
        expect(r).toEqual(response)

  describe 'getSearchRecords', ->
    next = response = undefined

    beforeEach ->
      next = false
      response = new Response({})
      spyOn(crmModule,'buildUrl').andReturn({})
      spyOn(Request.prototype,'request').andCallFake( (cb) ->
        setImmediate(cb,null,response)
      )

    it 'requires query object', ->
      expect( () -> crmModule.getSearchRecords() ).toThrow('Requires a query object')

    it 'requires searchCondition object', ->
      expect( () -> crmModule.getSearchRecords({}) ).toThrow('Requires a searchCondition to fetch')

    it 'build Url', ->
      crmModule.getSearchRecords({searchCondition: '(Start DateTime|starts with|2014-09-22)', selectColumns : 'All'},undefined)
      expect(crmModule.buildUrl).toHaveBeenCalledWith(
        {searchCondition: '(Start DateTime|starts with|2014-09-22)', selectColumns : 'All', newFormat:1},
        ['getSearchRecords'],
        {method:'GET'}
      )

    it 'calls callback with response', ->
      r = undefined
      runs ->
        crmModule.getSearchRecords({searchCondition: '(Start DateTime|starts with|2014-09-22)'}, (err,_r) ->
          r = _r
          next = true
        )
      waitsFor ->
        return next
      runs ->
        expect(r).toEqual(response)

  describe 'searchRecords', ->
    next = response = undefined

    beforeEach ->
      next = false
      response = new Response({})
      spyOn(crmModule,'buildUrl').andReturn({})
      spyOn(Request.prototype,'request').andCallFake( (cb) ->
        setImmediate(cb,null,response)
      )

    it 'requires query object', ->
      expect( () -> crmModule.searchRecords() ).toThrow('Requires a query object')

    it 'requires criteria object', ->
      expect( () -> crmModule.searchRecords({}) ).toThrow('Requires a criteria to fetch')

    it 'build Url', ->
      crmModule.searchRecords({criteria: '(Start DateTime:2014-09-22)', selectColumns : 'All'},undefined)
      expect(crmModule.buildUrl).toHaveBeenCalledWith(
        {criteria: '(Start DateTime:2014-09-22)', selectColumns : 'All', newFormat:1},
        ['searchRecords'],
        {method:'GET'}
      )

    it 'calls callback with response', ->
      r = undefined
      runs ->
        crmModule.searchRecords({criteria: '(Start DateTime|starts with|2014-09-22)'}, (err,_r) ->
          r = _r
          next = true
        )
      waitsFor ->
        return next
      runs ->
        expect(r).toEqual(response)

  describe 'uploadFile', ->
    fakeForm = fakeFile = fakeDescriptor = response = undefined

    beforeEach ->
      fakeForm = {append: ->}
      fakeFile = {}
      fakeDescriptor = {}
      response = {a: 1}

      spyOn(crmModule,'buildUrl').andReturn({})
      spyOn(Request.prototype, 'request').andCallFake( (cb) ->
        setImmediate(cb, null, response)

        {form: -> fakeForm}
      )

    it 'builds correct url', ->
      crmModule.uploadFile '1234567890123456', fakeFile, fakeDescriptor

      expect(crmModule.buildUrl).toHaveBeenCalledWith {}, ['uploadFile'], {method: 'POST'}

    it 'appends data into multipart request', ->
      spy = spyOn fakeForm, 'append'

      crmModule.uploadFile '1234567890123456', fakeFile, fakeDescriptor

      expect(spy).toHaveBeenCalledWith 'id', '1234567890123456'
      expect(spy).toHaveBeenCalledWith 'content', fakeFile, fakeDescriptor

    it 'appends file url to request', ->
      fakeFile = 'http://fake.string/url.ext'
      spy = spyOn fakeForm, 'append'

      crmModule.uploadFile '1234567890123456', fakeFile

      expect(spy).toHaveBeenCalledWith 'id', '1234567890123456'
      expect(spy).toHaveBeenCalledWith 'attachmentUrl', fakeFile

    it 'calls callback with response', ->
      spy = jasmine.createSpy('callback')

      crmModule.uploadFile '1234567890123456', fakeFile, fakeDescriptor, spy

      waitsFor ->
        if (spy.callCount == 1)
          expect(spy).toHaveBeenCalledWith(null, {a: 1, data: {}})

          true

  describe 'deleteFile', ->
    fakeForm = response = undefined

    beforeEach ->
      fakeForm = {append: ->}
      response = {a: 1}

      spyOn(crmModule,'buildUrl').andReturn({})
      spyOn(Request.prototype, 'request').andCallFake( (cb) ->
        setImmediate(cb, null, response)

        {form: -> fakeForm}
      )

    it 'builds correct url', ->
      crmModule.deleteFile '1234567890123456'

      expect(crmModule.buildUrl).toHaveBeenCalledWith {}, ['deleteFile'], {method: 'POST'}

    it 'appends id into multipart request', ->
      spy = spyOn fakeForm, 'append'

      crmModule.deleteFile '1234567890123456'

      expect(spy).toHaveBeenCalledWith 'id', '1234567890123456'

    it 'calls callback with response', ->
      spy = jasmine.createSpy('callback')

      crmModule.deleteFile '1234567890123456', spy

      waitsFor ->
        if (spy.callCount == 1)
          expect(spy).toHaveBeenCalledWith(null, {a: 1, data: {}})

          true
