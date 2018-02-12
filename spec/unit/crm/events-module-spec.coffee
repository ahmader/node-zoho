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
