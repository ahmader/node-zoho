help = require("../lib/helpers")
zoho = require("../lib/node-zoho")

describe "node-zoho", ->
  results = errors = done = undefined

  beforeEach ->
    results = errors = done = undefined

  it "has a constructor", ->
    options = {
      authToken: ""
    }

    lead =
      "Lead Source" : "Site Registration"
      "First Name"  : "Hannah"
      "Last Name"   : "Smith"
      Email: "belfordz66@gmail.com"

    runs ->
      za = new zoho(options)
      za.insertRecords("leads", lead, (err, res) ->
        errors = err
        results = res
        done = true
      )

    waitsFor ->
      return done

    runs ->
      expect(errors).toBe(null)

