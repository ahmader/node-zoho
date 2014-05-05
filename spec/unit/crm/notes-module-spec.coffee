_ = require('underscore')


Events = require('../../../lib/products/crm/notes')
CrmModule = require('../../../lib/products/crm/crm-module')
CrmProduct = require('../../../lib/products/crm')
Request = require('../../../lib/request')
Response = require('../../../lib/response')

describe 'notes', ->
  events = record = product = undefined
  zoho = {authToken:'TOKEN'}

  beforeEach ->
    product = new CrmProduct(zoho)
    events = new Events(product)
    record = {
      entityId: "1231321331313",
      "Note Title"  : "Zoho CRM Sample Note",
      "Note Content": "This is a memo"
    }

  it 'extends CrmModule', ->
    expect(Events.__super__.constructor).toEqual(CrmModule)

  it 'has name Notes', ->
    expect(events.name).toEqual('Notes')
