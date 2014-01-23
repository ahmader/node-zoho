Request = require('../../lib/request')

describe 'request', ->

  describe 'constructor', ->
    module = { fake: 'module' }
    _request = {}

    it 'requires module', ->
      expect( () -> new Request() ).toThrow()

    it 'requests request', ->
      expect( () -> new Request(module) ).toThrow()

    it 'assigns module to property', ->
      request = new Request(module,_request)
      expect(request.module).toBeDefined()
      expect(request.module).toEqual(module)

    it 'assigns request to property', ->
      request = new Request(module,_request)
      expect(request._request).toBeDefined()
      expect(request._request).toEqual(_request)
