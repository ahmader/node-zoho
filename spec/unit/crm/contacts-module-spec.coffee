_ = require('underscore')


Contacts = require('../../../lib/products/crm/contacts')
CrmModule = require('../../../lib/products/crm/crm-module')
CrmProduct = require('../../../lib/products/crm')
Request = require('../../../lib/request')
Response = require('../../../lib/response')

describe 'contacts', ->
  contacts = record = product = undefined
  zoho = {authToken:'TOKEN'}

  beforeEach ->
    product = new CrmProduct(zoho)
    contacts = new Contacts(product)
    record = {
      "Contact Source": "Unit Test",
      "First Name": "Test",
      "Last Name": "Testerson",
      "Email": "test@testerson.com"
    }

  it 'extends CrmModule', ->
    expect(Contacts.__super__.constructor).toEqual(CrmModule)

  it 'has name Contacts', ->
    expect(contacts.name).toEqual('Contacts')
