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
    response = next = undefined

    beforeEach ->
      response = new Response({})
      next = false

    it 'requires body param', ->
      expect(() -> response.parseBody()).toThrow('Requires body')

    it 'requires cb param', ->
      expect(() -> response.parseBody({})).toThrow('Requires callback')

    it 'returns XML error on invalid XML', ->
      e = null
      runs ->
        response.parseBody('<?xml ><asdf ></text>', (err) ->
          e = err
          next = true
        )
      waitsFor ->
        return next
      runs ->
        expect(e).not.toBe(null)
        expect(e.constructor.name).toBe('Error')

    it 'returns response with no error on valid response', ->
      e = null
      runs ->
        response.parseBody('<?xml version="1.0" encoding="UTF-8"?><root><item name="test"><contains><thing name="thing1"/><thing name="thing2"/></contains></item></root>', (err, result) ->
          r = result
          next = true
        )
      waitsFor ->
        return next
      runs ->
        expect(r.data).toEqual({ root : { item : [ { $ : { name : 'test' }, contains : [ { thing : [ { $ : { name : 'thing1' } }, { $ : { name : 'thing2' } } ] } ] } ] } })

    describe 'parseString', ->

      it 'calls callback with error response', ->
        r = undefined
        runs ->
          response.parseBody('<?xml version="1.0" encoding="UTF-8"?><response uri="/crm/private/xml/Events/getRecords"><error><code>4834</code><message>Invalid Ticket Id</message></error></response>', (err,_r) ->
            r = _r
            next = true
          )
        waitsFor ->
          return next
        runs ->
          expect(r.data.response.error).toEqual([{code:["4834"], message:["Invalid Ticket Id"]}])

      it 'calls callback with nodata response', ->
        r = undefined
        runs ->
          response.parseBody('<?xml version="1.0" encoding="UTF-8"?><response uri="/crm/private/xml/Events/getRecords"><nodata><code>4422</code><message>There is no data to show</message></nodata></response>', (err,_r) ->
            r = _r
            next = true
          )
        waitsFor ->
          return next
        runs ->
          expect(r.data.response.nodata).toEqual([{code:["4422"], message:["There is no data to show"]}])
