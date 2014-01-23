BaseModule = require('../../lib/base-module')

describe 'base-module', ->
  baseModule = undefined
  product = { fake: 'instance' }

  beforeEach ->
    baseModule = new BaseModule(product)

  describe 'constructor', ->

    it 'throws exception if not provided product', ->
      expect( () -> new BaseModule() ).toThrow()

    it 'assigns product to property', ->
      baseModule = new BaseModule(product)
      expect(baseModule.product).toEqual(product)

  describe 'name', ->

    it 'default to BaseName', ->
      expect(baseModule.name).toEqual('BaseModule')

  describe 'format', ->

    it 'defaults to xml', ->
      expect(baseModule.format).toEqual('xml')

  describe 'scope', ->

    it 'defaults to private', ->
      expect(baseModule.scope).toEqual('private')

  describe 'getUrlParts', ->

    it 'returns scope, format, name in array', ->
      expect(baseModule.getUrlParts()).toEqual(['private','xml','BaseModule'])
