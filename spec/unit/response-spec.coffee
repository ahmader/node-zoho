Response = require('../../lib/response')

describe 'response', ->
  response = r = body = undefined

  beforeEach ->
    r = {}
    body = ""
    response = new Response(r)

  it 'has message', ->
    expect(response.message).toBeDefined()

  it 'has type', ->
    expect(response.type).toBeDefined()

  it 'has data', ->
    expect(response.data).toBeDefined()

  describe 'constructor', ->

    it 'requires https response', ->
      expect( () -> new Response() ).toThrow("Requires response")

  describe 'parseResponse', ->

    it 'requires body param', ->
      expect(() -> response.parseBody()).toThrow('Requires body')

    it 'requires cb param', ->
      expect(() -> response.parseBody({})).toThrow('Requires callback')

    it 'returns XML error on invalid XML', ->

    it 'returns error on error formatted response' , ->

    it 'returns response with no error on valid response', ->
