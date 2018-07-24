CrmProduct = require('../../../lib/products/crm')
BaseProduct = require('../../../lib/base-product')

describe 'crm', ->
  Crm = undefined
  zoho = { authToken: 'fake-token', region: 'com' }

  beforeEach ->
    Crm = new CrmProduct(zoho)

  it 'extends BaseProduct', ->
    expect(CrmProduct.__super__.constructor).toEqual(BaseProduct)

  it 'has name crm', ->
    expect(Crm.name).toBe('crm')

  describe 'getModules', ->

    it 'returns array', ->
      expect(Crm.getModules()).toBeDefined()

    it 'contains implemented modules', ->
      expect(Crm.getModules()).toEqual(['Leads', 'Events', 'Potentials', 'Contacts', 'Accounts', 'CustomModule1'])

  describe 'getModule', ->

    it 'throws exception if module not found', ->
      expect(() -> Crm.getModule('Invalid') ).toThrow()

    it 'returns instance of valid module', ->
      leads = Crm.getModule('Leads')

      expect(leads).toBeDefined()

  describe 'getScope', ->

    it 'returns crmapi', ->
      expect(Crm.getScope()).toBe('crmapi')

  describe 'getBaseUrl', ->

    it 'returns hosnamet: crm.zoho.com', ->
      expect(Crm.getBaseUrl().hostname).toBe('crm.zoho.com')

    it 'returns hostname: crm.zoho.com', ->
      sandboxCrm = new CrmProduct(Object.assign({isSandbox: true}, zoho))
      expect(sandboxCrm.getBaseUrl().hostname).toBe('crmsandbox.zoho.com')

    it 'protocol https', ->
      expect(Crm.getBaseUrl().protocol).toBe('https')

    it 'has default query', ->
      expect(Crm.getBaseUrl().query).toEqual({
        authtoken: zoho.authToken
        scope: 'crmapi'
      })

    it 'has path with name', ->
      expect(Crm.getBaseUrl().path).toEqual(['crm'])
