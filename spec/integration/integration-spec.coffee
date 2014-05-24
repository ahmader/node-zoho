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
        expect(errors).toBe(null)
        expect(response).toBeDefined()

        # expect(results.isError()).toBeFalsy()
        #

    describe "events", ->
      event =
        "Subject": "Conference"
        "Start DateTime": "2014-01-01 12:30:00"
        "End DateTime": "2014-01-01 12:30:00"
        "Venue": "Mystery Theater"
        "Send Notification Email": "False"

      it "can create event", ->
        runs ->
          za.execute('crm','Events','insertRecords',[event], (err, _response) ->
            errors = err
            response = _response
            done = true
          )

        waitsFor ->
          return done

        runs ->
          event_id = response.data.Id
          expect(errors).toBe(null)
          expect(response).toBeDefined()

      it "can get event by id", ->
        runs ->
          za.execute('crm','Events','insertRecords',[event], (err, _response) ->
            errors = err
            response = _response
            done = true
          )

        waitsFor ->
          return done

        runs ->
          done = false
          za.execute('crm','Events','getRecordById',response.data.Id, (err, _response) ->
            errors = err
            response = _response
            done = true
          )

        waitsFor ->
          return done

        runs ->
          expect(errors).toBe(null)
          expect(response).toBeDefined()

      it "can fetch all events", ->
        runs ->
          za.execute('crm','Events','getRecords',{}, (err, _response) ->
            errors = err
            response = _response
            done = true
          )

        waitsFor ->
          return done

        runs ->
          expect(errors).toBe(null)
          expect(response).toBeDefined()
          expect(response.data).toEqual(jasmine.any(Array))

    describe "contacts", ->
      contact =
        "First Name"  : "Test"
        "Last Name"   : "Testerson"
        "Email"       : "test@testerson.com"

      it "can create contact", ->
        runs ->
          za.execute('crm','Contacts','insertRecords',[contact], (err, _response) ->
            errors = err
            response = _response
            done = true
          )

        waitsFor ->
          return done

        runs ->
          contact_id = response.data.Id
          expect(errors).toBe(null)
          expect(response).toBeDefined()

    describe "products", ->
      product =
        "Product Name"  : "TestProduct"
        "Unit Price"    : "15"
        "Tax"           : "2"

      it "can create contact", ->
        runs ->
          za.execute('crm','Products','insertRecords',[product], (err, _response) ->
            errors = err
            response = _response
            done = true
          )

        waitsFor ->
          return done

        runs ->
          product_id = response.data.Id
          expect(product_id).toBeDefined()
          expect(errors).toBe(null)
          expect(response).toBeDefined()