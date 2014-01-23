BaseProduct = require('../../lib/base-product')

describe 'base-product', ->
  baseProduct = undefined
  zoho = { instance: 'fake' }

  beforeEach ->
    baseProduct = new BaseProduct(zoho)

  describe 'constructor', ->

    it 'requires zoho instance', ->
      expect(() -> new BaseProduct()).toThrow()

    it 'assigns zoho instance to property', ->
      baseProduct = new BaseProduct(zoho)
      expect(baseProduct.zoho).toEqual(zoho)

  it "has name", ->
    expect(baseProduct.name).toBe('base_product')

