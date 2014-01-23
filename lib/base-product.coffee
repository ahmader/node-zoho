class BaseProduct
  name: 'base_product'

  constructor: (@zoho) ->
    if not @zoho
      throw new Error('Expected object for zoho')

module.exports = BaseProduct
