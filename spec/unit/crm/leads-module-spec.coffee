_ = require('underscore')


Leads = require('../../../lib/products/crm/leads')
BaseModule = require('../../../lib/base-module')
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
    expect(Leads.__super__.constructor).toEqual(BaseModule)

  it 'has name Leads', ->
    expect(leads.name).toEqual('Leads')

  describe 'insertRecords', ->
    response = next = undefined

    beforeEach ->
      spyOn(leads,'build').andReturn('<?xml version="1.0" encoding="UTF-8"?><Leads/>')
      response = new Response()
      next = false
      spyOn(Request.prototype,'request').andCallFake( (cb) ->
        setImmediate(cb,null,response)
      )

    it 'requires array', ->
      expect( () -> leads.insertRecords(record,() -> ) ).toThrow('Requires array of records')

    it 'requires at least one record', ->
      expect( () -> leads.insertRecords([],() -> ) ).toThrow('Requires as least one record')

    it 'calls buildRecords', ->
      leads.insertRecords([record],undefined)
      expect(leads.build).toHaveBeenCalledWith([record])

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





