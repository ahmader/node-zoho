_ = require('underscore')


Events = require('../../../lib/products/crm/events')
CrmModule = require('../../../lib/products/crm/crm-module')
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

  it 'extends CrmModule', ->
    expect(Events.__super__.constructor).toEqual(CrmModule)

  it 'has name Events', ->
    expect(events.name).toEqual('Events')

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




