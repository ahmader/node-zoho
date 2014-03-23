_ = require('underscore')


Events = require('../../../lib/products/crm/events')
BaseModule = require('../../../lib/base-module')
CrmProduct = require('../../../lib/products/crm')
Request = require('../../../lib/request')
Response = require('../../../lib/response')

describe 'events', ->
  events = record = product = undefined
  zoho = {authToken:'TOKEN'}

  beforeEach ->
    product = new CrmProduct(zoho)
    events = new Events(product)
    record = {
      "Lead Source": "Unit Test",
      "First Name": "Test",
      "Last Name": "Testerson",
      "Email": "test@testerson.com"
    }

  it 'extends BaseModule', ->
    expect(Events.__super__.constructor).toEqual(BaseModule)

  it 'has name Events', ->
    expect(events.name).toEqual('Events')

  describe 'insertRecords', ->
    response = next = undefined

    beforeEach ->
      spyOn(events,'build').andReturn('<?xml version="1.0" encoding="UTF-8"?><Events/>')
      response = new Response({})
      next = false
      spyOn(Request.prototype,'request').andCallFake( (cb) ->
        setImmediate(cb,null,response)
      )
      spyOn(events,'buildUrl').andReturn({})
      spyOn(events,'processRecord').andReturn({})

    it 'requires array', ->
      expect( () -> events.insertRecords(record,() -> ) ).toThrow('Requires array of records')

    it 'requires at least one record', ->
      expect( () -> events.insertRecords([],() -> ) ).toThrow('Requires as least one record')

    it 'calls buildRecords', ->
      events.insertRecords([record],undefined)
      expect(events.build).toHaveBeenCalledWith([record])

    it 'builds Url', ->
      events.insertRecords([record],undefined)
      expect(events.buildUrl).toHaveBeenCalledWith(
        {newFormat:1,xmlData:'<?xml version="1.0" encoding="UTF-8"?><Events/>'},
        ['insertRecords'],
        {method:'POST'}
      )

    it 'calls callback with response', ->
      r = undefined
      runs ->
        events.insertRecords([record], (err,_r) ->
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
      spyOn(events,'buildUrl').andReturn({})
      spyOn(Request.prototype,'request').andCallFake( (cb) ->
        setImmediate(cb,null,response)
      )

    it 'requires record id param', ->
      expect( () -> events.getRecordById() ).toThrow('Requires an Id to fetch')

    it 'build Url', ->
      events.getRecordById('1234567890123456',undefined)
      expect(events.buildUrl).toHaveBeenCalledWith(
        {id:'1234567890123456', newFormat:1},
        ['getRecordById'],
        {method:'GET'}
      )

    it 'calls callback with response', ->
      r = undefined
      runs ->
        events.getRecordById('1234567890123456', (err,_r) ->
          r = _r
          next = true
        )
      waitsFor ->
        return next
      runs ->
        expect(r).toEqual(response)

  describe 'convertLead', ->
    next = response = undefined
    beforeEach ->
      next = false
      response = new Response({})
      spyOn(Request.prototype,'request').andCallFake( (cb) ->
        setImmediate(cb,null,response)
      )
      spyOn(events,'build').andReturn('<?xml version="1.0" encoding="UTF-8"?><Events/>')
      spyOn(events,'buildUrl').andReturn({})
    it 'requires lead_id param', ->
      expect( () -> events.convertLead() ).toThrow('Requires a Lead Id')

    it 'requires options', ->
      expect( () -> events.convertLead('1234567890123456') ).toThrow('Requires an options')

    it 'requires options.potential if options.createPotential true', ->
      expect( () -> events.convertLead('1234567890123456',{createPotential:true}) ).toThrow('Requires a potential')

    it 'build Url', ->
      events.convertLead('1234567890123456',{},undefined)
      expect(events.buildUrl).toHaveBeenCalledWith(
        {leadId:'1234567890123456', newFormat:1,xmlData:'<?xml version="1.0" encoding="UTF-8"?><Events/>'},
        ['convertLead'],
        {method:'POST'}
      )

    it 'calls callback with response', ->
      r = undefined
      runs ->
        events.convertLead('1234567890123456', {}, (err,_r) ->
          r = _r
          next = true
        )
      waitsFor ->
        return next
      runs ->
        expect(r).toEqual(response)

  describe 'build', ->
    beforeEach ->
      spyOn(events,'buildRecords').andReturn([{$:{no:1},FL:[{_:'TEST'},{_:'TEST2'}]}])

    it 'accepts array', ->

    it 'returns string', ->

    it 'calls buildRecords', ->
      events.build([record])
      expect(events.buildRecords).toHaveBeenCalledWith([record])

    it 'returns expected string', ->
      result = events.build([record])
      expect(result).toMatch(/\?xml/)
      expect(result).toMatch('<row no="1"')
      expect(result).toMatch('<FL>TEST</FL>')


  describe 'buildRecord', ->

    it "accepts Object", ->
      expect(() -> events.buildRecord("asdf")).toThrow('Object required')

    it "returns Array", ->
      result = events.buildRecord({})
      expect(_.isArray(result)).toBeTruthy()

    it "key in to $.val", ->
      result = events.buildRecord({test:'value'})
      expect(result.length).toEqual(1)
      expect(result[0].$.val).toEqual('test')

    it "value to be in _", ->
      result = events.buildRecord({test:'value'})
      expect(result.length).toEqual(1)
      expect(result[0]._).toEqual('value')

  describe 'buildRecords', ->
    record_set = undefined

    beforeEach ->
      record_set = [ record ]

    it "requires array", ->
      expect( () -> events.buildRecords({})).toThrow('Requires array of records')

    it "returns array", ->

      result = events.buildRecords(record_set)
      expect(_.isArray(result)).toBeTruthy()

    it "calls buildRecord", ->
      spyOn(events,'buildRecord').andReturn([])
      result = events.buildRecords(record_set)
      expect(events.buildRecord).toHaveBeenCalledWith(record)

    it "sets row no", ->
      result = events.buildRecords(record_set)
      expect(result[0].$.no).toBe(1)

    it "sets record on FL", ->
      _record = [ 'a','record' ]
      spyOn(events,'buildRecord').andReturn(_record)
      result = events.buildRecords(record_set)
      expect(result[0].FL).toEqual(_record)

  describe 'processRecord', ->

    describe "single FL response", ->
      compiled_record = undefined

      beforeEach ->
        compiled_record = events.buildRecord(record)

      it 'handles FL array', ->
        compiled_record = { FL: [ {$:{val:"test"},_:"value"}]}
        processed = events.processRecord(compiled_record)
        expect(processed).toEqual({test:"value"})

      it 'handles complicated response', ->
        compiled_record = [{"FL":[{"_":"953419000000673233","$":{"val":"Id"}},{"_":"2014-01-23 14:55:23","$":{"val":"Created Time"}},{"_":"2014-01-23 14:55:23","$":{"val":"Modified Time"}},{"_":"Parmar","$":{"val":"Created By"}},{"_":"Parmar","$":{"val":"Modified By"}}]}]
        processed = events.processRecord(compiled_record)
        expect(processed).toEqual({ Id : '953419000000673233', "Created Time" : '2014-01-23 14:55:23', "Modified Time" : '2014-01-23 14:55:23', "Created By" : 'Parmar', "Modified By" : 'Parmar' })


    describe "param labeled row", ->

      it "returns single object with key and value", ->
        expect(events.processRecord({_:"value",$:{param:"key"}})).toEqual({key:"value"})

    describe "val labeled row", ->

      it "returns single object with key and value", ->
        expect(events.processRecord({_:"value",$:{val:"key"}})).toEqual({key:"value"})

    describe "simple success", ->
      # <success><Contact param="id">1071983000000078003</Contact></success>
      single_response = {"success":{"Contact":[{"_":"1071983000000075005","$":{"param":"id"}}]}}
      multiple_response = {"success":{"Contact":[{"_":"1071983000000075009","$":{"param":"id"}}],
      "Potential":[{"_":"1071983000000075011","$":{"param":"id"}}]}}

      it "single response", ->
        processed = events.processRecord(single_response)
        expect(processed).toEqual({Contact: {id:'1071983000000075005'}})

      it "multiple response", ->
        processed = events.processRecord(multiple_response)
        expect(processed).toEqual({Contact: {id:'1071983000000075009'},Potential: {id:'1071983000000075011'}})




