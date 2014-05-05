CrmModule = require('../../../lib/products/crm/crm-module')
BaseModule = require('../../../lib/base-module')

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
