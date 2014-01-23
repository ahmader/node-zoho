Response = require('../../lib/response')

describe 'response', ->
  response = undefined

  beforeEach ->
    response = new Response()

  it 'has message', ->
    expect(response.message).toBeDefined()

  it 'has type', ->
    expect(response.type).toBeDefined()

  it 'has data', ->
    expect(response.data).toBeDefined()

  describe 'constructor', ->

    it 'requires https response', ->

  describe 'handleChunk', ->

    it "callsbacks with error", ->

    it "appends to _data", ->

  describe 'handleEnd', ->

    it 'callsback with error on non 200 response', ->

    it 'calls parseResponse', ->

  describe '_parseResponse', ->
    it 'returns XML error on invalid XML', ->

    it 'returns error on error formatted response' , ->

    it 'returns response with no error on valid response', ->





