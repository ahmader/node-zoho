help = require("../../lib/helpers")
zoho = require("../../lib/node-zoho")
config = require('../config.json')

describe "integration", ->
  results = errors = done = za = undefined

  beforeEach ->
    results = errors = done = undefined
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
      za.insertRecords("leads", lead, (err, res) ->
        errors = err
        results = res
        done = true
      )

    waitsFor ->
      return done

    runs ->
      expect(errors).toBe(null)

