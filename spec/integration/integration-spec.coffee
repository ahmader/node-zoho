help = require("../../lib/helpers")
zoho = require("../../lib/node-zoho")
config = require('../config.json')


# only run when we have a token
if config.authToken and config.enabled

  describe "integration", ->
    response = errors = done = za = undefined

    beforeEach ->
      response = errors = done = undefined
      za = new zoho({
        authToken: config.authToken
      })


    it "can create lead", ->
      lead =
        "Lead Source" : "Site Registration"
        "First Name"  : "Test"
        "Last Name"   : "Testerson"
        "Email"       : "test@testerson.com"

      runs ->
        za.execute('crm','Leads','insertRecords',[lead], (err, _response) ->
          errors = err
          response = _response
          done = true
        )

      waitsFor ->
        return done

      runs ->
        console.log(response.data)
        expect(errors).toBe(null)
        expect(response).toBeDefined()

        # expect(results.isError()).toBeFalsy()

