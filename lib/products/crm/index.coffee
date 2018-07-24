BaseProduct = require('../../base-product')

class CrmProduct extends BaseProduct
  name: 'crm'

  getModules: ->
    return ['Leads', 'Events', 'Potentials', 'Contacts', 'Accounts', 'CustomModule1']

  getModule: (module_name) ->
    try
      module_name = module_name.toLowerCase()
      module_path = "./#{module_name}"
      require.resolve(module_path)
      module_class = require(module_path)
    catch err
      throw new Error(err)

    instance = new module_class(@)

    return instance

  getScope: ->
    return 'crmapi'

  getBaseUrl: ->
    sandboxPart = if @zoho.isSandbox then 'sandbox' else ''
    return {
      hostname: "crm#{sandboxPart}.zoho.#{@zoho.region}"
      protocol: 'https'
      query: {
        authtoken: @zoho.authToken
        scope: @getScope()
      }
      path: [ @name ]
    }

module.exports = CrmProduct
