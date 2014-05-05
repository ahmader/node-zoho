_ = require('underscore')


Leads = require('../../../lib/products/crm/leads')
CrmModule = require('../../../lib/products/crm/crm-module')
CrmProduct = require('../../../lib/products/crm')
Request = require('../../../lib/request')
Response = require('../../../lib/response')

describe 'leads', ->
  leads = record = product = undefined
  zoho = {authToken:'TOKEN'}

  beforeEach ->
    product = new CrmProduct(zoho)
    leads = new Leads(product)
    record = {
      "Lead Source": "Unit Test",
      "First Name": "Test",
      "Last Name": "Testerson",
      "Email": "test@testerson.com"
    }

  it 'extends BaseModule', ->
    expect(Leads.__super__.constructor).toEqual(CrmModule)

  it 'has name Leads', ->
    expect(leads.name).toEqual('Leads')

  describe 'insertRecords', ->
    response = next = undefined

    beforeEach ->
      spyOn(leads,'build').andReturn('<?xml version="1.0" encoding="UTF-8"?><Leads/>')
      response = new Response({})
      next = false
      spyOn(Request.prototype,'request').andCallFake( (cb) ->
        setImmediate(cb,null,response)
      )
      spyOn(leads,'buildUrl').andReturn({})
      spyOn(leads,'processRecord').andReturn({})

    it 'requires array', ->
      expect( () -> leads.insertRecords(record,() -> ) ).toThrow('Requires array of records')

    it 'requires at least one record', ->
      expect( () -> leads.insertRecords([],() -> ) ).toThrow('Requires as least one record')

    it 'calls buildRecords', ->
      leads.insertRecords([record],undefined)
      expect(leads.build).toHaveBeenCalledWith([record])

    it 'builds Url', ->
      leads.insertRecords([record],undefined)
      expect(leads.buildUrl).toHaveBeenCalledWith(
        {newFormat:1,xmlData:'<?xml version="1.0" encoding="UTF-8"?><Leads/>'},
        ['insertRecords'],
        {method:'POST'}
      )

    it 'calls callback with response', ->
      r = undefined
      runs ->
        leads.insertRecords([record], (err,_r) ->
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
      spyOn(leads,'buildUrl').andReturn({})
      spyOn(Request.prototype,'request').andCallFake( (cb) ->
        setImmediate(cb,null,response)
      )

    it 'requires record id param', ->
      expect( () -> leads.getRecordById() ).toThrow('Requires an Id to fetch')

    it 'build Url', ->
      leads.getRecordById('1234567890123456',undefined)
      expect(leads.buildUrl).toHaveBeenCalledWith(
        {id:'1234567890123456', newFormat:1},
        ['getRecordById'],
        {method:'GET'}
      )

    it 'calls callback with response', ->
      r = undefined
      runs ->
        leads.getRecordById('1234567890123456', (err,_r) ->
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
      spyOn(leads,'build').andReturn('<?xml version="1.0" encoding="UTF-8"?><Leads/>')
      spyOn(leads,'buildUrl').andReturn({})
    it 'requires lead_id param', ->
      expect( () -> leads.convertLead() ).toThrow('Requires a Lead Id')

    it 'requires options', ->
      expect( () -> leads.convertLead('1234567890123456') ).toThrow('Requires an options')

    it 'requires options.potential if options.createPotential true', ->
      expect( () -> leads.convertLead('1234567890123456',{createPotential:true}) ).toThrow('Requires a potential')

    it 'build Url', ->
      leads.convertLead('1234567890123456',{},undefined)
      expect(leads.buildUrl).toHaveBeenCalledWith(
        {leadId:'1234567890123456', newFormat:1,xmlData:'<?xml version="1.0" encoding="UTF-8"?><Leads/>'},
        ['convertLead'],
        {method:'POST'}
      )

    it 'calls callback with response', ->
      r = undefined
      runs ->
        leads.convertLead('1234567890123456', {}, (err,_r) ->
          r = _r
          next = true
        )
      waitsFor ->
        return next
      runs ->
        expect(r).toEqual(response)

  describe 'build', ->
    beforeEach ->
      spyOn(leads,'buildRecords').andReturn([{$:{no:1},FL:[{_:'TEST'},{_:'TEST2'}]}])

    it 'accepts array', ->

    it 'returns string', ->

    it 'calls buildRecords', ->
      leads.build([record])
      expect(leads.buildRecords).toHaveBeenCalledWith([record])

    it 'returns expected string', ->
      result = leads.build([record])
      expect(result).toMatch(/\?xml/)
      expect(result).toMatch('<row no="1"')
      expect(result).toMatch('<FL>TEST</FL>')


  describe 'buildRecord', ->

    it "accepts Object", ->
      expect(() -> leads.buildRecord("asdf")).toThrow('Object required')

    it "returns Array", ->
      result = leads.buildRecord({})
      expect(_.isArray(result)).toBeTruthy()

    it "key in to $.val", ->
      result = leads.buildRecord({test:'value'})
      expect(result.length).toEqual(1)
      expect(result[0].$.val).toEqual('test')

    it "value to be in _", ->
      result = leads.buildRecord({test:'value'})
      expect(result.length).toEqual(1)
      expect(result[0]._).toEqual('value')

  describe 'buildRecords', ->
    record_set = undefined

    beforeEach ->
      record_set = [ record ]

    it "requires array", ->
      expect( () -> leads.buildRecords({})).toThrow('Requires array of records')

    it "returns array", ->

      result = leads.buildRecords(record_set)
      expect(_.isArray(result)).toBeTruthy()

    it "calls buildRecord", ->
      spyOn(leads,'buildRecord').andReturn([])
      result = leads.buildRecords(record_set)
      expect(leads.buildRecord).toHaveBeenCalledWith(record)

    it "sets row no", ->
      result = leads.buildRecords(record_set)
      expect(result[0].$.no).toBe(1)

    it "sets record on FL", ->
      _record = [ 'a','record' ]
      spyOn(leads,'buildRecord').andReturn(_record)
      result = leads.buildRecords(record_set)
      expect(result[0].FL).toEqual(_record)

  describe 'processRecord', ->

    describe "single FL response", ->
      compiled_record = undefined

      beforeEach ->
        compiled_record = leads.buildRecord(record)

      it 'handles FL array', ->
        compiled_record = { FL: [ {$:{val:"test"},_:"value"}]}
        processed = leads.processRecord(compiled_record)
        expect(processed).toEqual({test:"value"})

      it 'handles complicated response', ->
        compiled_record = [{"FL":[{"_":"953419000000673233","$":{"val":"Id"}},{"_":"2014-01-23 14:55:23","$":{"val":"Created Time"}},{"_":"2014-01-23 14:55:23","$":{"val":"Modified Time"}},{"_":"Parmar","$":{"val":"Created By"}},{"_":"Parmar","$":{"val":"Modified By"}}]}]
        processed = leads.processRecord(compiled_record)
        expect(processed).toEqual({ Id : '953419000000673233', "Created Time" : '2014-01-23 14:55:23', "Modified Time" : '2014-01-23 14:55:23', "Created By" : 'Parmar', "Modified By" : 'Parmar' })


    describe "param labeled row", ->

      it "returns single object with key and value", ->
        expect(leads.processRecord({_:"value",$:{param:"key"}})).toEqual({key:"value"})

    describe "val labeled row", ->

      it "returns single object with key and value", ->
        expect(leads.processRecord({_:"value",$:{val:"key"}})).toEqual({key:"value"})

    describe "simple success", ->
      # <success><Contact param="id">1071983000000078003</Contact></success>
      single_response = {"success":{"Contact":[{"_":"1071983000000075005","$":{"param":"id"}}]}}
      multiple_response = {"success":{"Contact":[{"_":"1071983000000075009","$":{"param":"id"}}],
      "Potential":[{"_":"1071983000000075011","$":{"param":"id"}}]}}

      it "single response", ->
        processed = leads.processRecord(single_response)
        expect(processed).toEqual({Contact: {id:'1071983000000075005'}})

      it "multiple response", ->
        processed = leads.processRecord(multiple_response)
        expect(processed).toEqual({Contact: {id:'1071983000000075009'},Potential: {id:'1071983000000075011'}})




