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

  it 'extends CrmModule', ->
    expect(Leads.__super__.constructor).toEqual(CrmModule)

  it 'has name Leads', ->
    expect(leads.name).toEqual('Leads')

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

  describe 'uploadFile', ->
    fakeForm = fakeFile = fakeDescriptor = response = undefined

    beforeEach ->
      fakeForm = {append: ->}
      fakeFile = {}
      fakeDescriptor = {}
      response = {a: 1}

      spyOn(leads,'buildUrl').andReturn({})
      spyOn(Request.prototype, 'request').andCallFake( (cb) ->
        setImmediate(cb, null, response)

        {form: -> fakeForm}
      )

    it 'builds correct url', ->
      leads.uploadFile '1234567890123456', fakeFile, fakeDescriptor

      expect(leads.buildUrl).toHaveBeenCalledWith {}, ['uploadFile'], {method: 'POST'}

    it 'appends data into multipart request', ->
      spy = spyOn fakeForm, 'append'

      leads.uploadFile '1234567890123456', fakeFile, fakeDescriptor

      expect(spy).toHaveBeenCalledWith 'id', '1234567890123456'
      expect(spy).toHaveBeenCalledWith 'content', fakeFile, fakeDescriptor

    it 'calls callback with response', ->
      spy = jasmine.createSpy('callback')

      leads.uploadFile '1234567890123456', fakeFile, fakeDescriptor, spy

      waitsFor ->
        if (spy.callCount == 1)
          expect(spy).toHaveBeenCalledWith(null, {a: 1, data: {}})

          true

  describe 'uploadPhoto', ->
    fakeForm = fakeFile = fakeDescriptor = response = undefined

    beforeEach ->
      fakeForm = {append: ->}
      fakeFile = {}
      fakeDescriptor = {}
      response = {a: 1}

      spyOn(leads,'buildUrl').andReturn({})
      spyOn(Request.prototype, 'request').andCallFake( (cb) ->
        setImmediate(cb, null, response)

        {form: -> fakeForm}
      )

    it 'builds correct url', ->
      leads.uploadPhoto '1234567890123456', fakeFile, fakeDescriptor

      expect(leads.buildUrl).toHaveBeenCalledWith {}, ['uploadPhoto'], {method: 'POST'}

    it 'appends data into multipart request', ->
      spy = spyOn fakeForm, 'append'

      leads.uploadPhoto '1234567890123456', fakeFile, fakeDescriptor

      expect(spy).toHaveBeenCalledWith 'id', '1234567890123456'
      expect(spy).toHaveBeenCalledWith 'content', fakeFile, fakeDescriptor

    it 'calls callback with response', ->
      spy = jasmine.createSpy('callback')

      leads.uploadPhoto '1234567890123456', fakeFile, fakeDescriptor, spy

      waitsFor ->
        if (spy.callCount == 1)
          expect(spy).toHaveBeenCalledWith(null, {a: 1, data: {}})

          true
