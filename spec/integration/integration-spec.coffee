fs = require('fs')
zoho = require("../../lib/node-zoho")
config = require('../config.json')

records =
  'Accounts' :
    "Account Name"  : "company"
  'Events' :
    "Subject": "Conference"
    "Start DateTime": "2014-01-01 12:30:00"
    "End DateTime": "2014-01-01 12:30:00"
    "Venue": "Mystery Theater"
    "Send Notification Email": "False"
  'Leads' :
    "Lead Source" : "Site Registration"
    "First Name"  : "Test"
    "Last Name"   : "Testerson"
    "Email"       : "test@testerson.com"
  'Contacts' :
    "First Name"  : "Test"
    "Last Name"   : "Testerson"
    "Email"       : "test@testerson.com"
  'Tasks' :
    "Subject"     : "Task"
    "Send Notification Email": "False"
  'Potentials' :
    "Potential Name" : "Potential"
  'SalesOrders' :
    "Subject"     : "Sales"
  'Invoices' :
    "Subject"     : "Invoice"

# only run when we have a token
if config.authToken and config.enabled

  describe "integration", ->
    response = errors = done = za = record_id = note_id = file_id = undefined

    beforeEach ->
      response = errors = done = undefined
      za = new zoho({
        authToken: config.authToken
      })
    
    Object.keys(records).map((crmModule) ->

      describe crmModule, ->
      
        record = records[crmModule]
        record_search = Object.keys(records[crmModule])[0]
        
        it "can get fields", ->

          runs ->
            # console.log 'getFields'
            za.execute('crm', crmModule,'getFields', {}, (err, _response) ->
              errors = err
              response = _response
              done = true
            )

          waitsFor ->
            return done

          runs ->
            # console.log "can get fields", errors, response.data[0].fields
            expect(errors).toBe(null)
            expect(response).toBeDefined()
            expect(response.data).toBeDefined()
            expect(response.data).toEqual(jasmine.any(Array))
            expect(response.data.length).toBeGreaterThan(0)
          
        
        it "can insert records", ->

          runs ->
            za.execute('crm', crmModule,'insertRecords', [record, record], (err, _response) ->
              errors = err
              response = _response
              done = true
            )

          waitsFor ->
            return done

          runs ->
            # console.log "can insert records", errors, response.data
            expect(errors).toBe(null)
            expect(response).toBeDefined()
            expect(response.data).toBeDefined()
            expect(response.data).toEqual(jasmine.any(Array))
            expect(response.data.length).toBeGreaterThan(0)
            record_id = response.data[0].Id
            
        it "can insert note", ->

          runs ->
            note = {"Note Title"  : "Note Title", 'entityId': record_id}
            za.execute('crm', 'Notes','insertRecords', [note, note], (err, _response) ->
              errors = err
              response = _response
              done = true
            )

          waitsFor ->
            return done

          runs ->
            # console.log "can insert notes", errors, response.data
            expect(errors).toBe(null)
            expect(response).toBeDefined()
            expect(response.data).toBeDefined()
            expect(response.data).toEqual(jasmine.any(Array))
            expect(response.data.length).toBeGreaterThan(0)
            note_id = response.data[0].Id
            
        it "can search records", ->
          
          runs ->
            # console.log 'searchRecords', {'criteria': '('+record_search+':'+record[record_search]+')'}
            za.execute('crm', crmModule, 'searchRecords', {'criteria': '('+record_search+':'+record[record_search]+')'}, (err, _response) ->
              errors = err
              response = _response
              done = true
            )

          waitsFor ->
            return done

          runs ->
            # console.log "can search records", errors, response.data
            expect(errors).toBe(null)
            expect(response).toBeDefined()
            expect(response.data).toEqual(jasmine.any(Array))
            expect(response.data.length).toBeGreaterThan(0)
            
        it "can get record by id", ->
          
          runs ->
            # console.log 'getRecordById', record_id
            za.execute('crm', crmModule, 'getRecordById', record_id, (err, _response) ->
              errors = err
              response = _response
              done = true
            )

          waitsFor ->
            return done

          runs ->
            # console.log "can get record by id", errors, response.data
            expect(errors).toBe(null)
            expect(response).toBeDefined()
            expect(response.data).toBeDefined()
            expect(response.data.SMOWNERID).toBeDefined()
            
        it "can update record by id", ->
          
          runs ->
            new_record = record #Object.assign({}, , {Objects.keys(record)[0]: record[Objects.keys(record)[0]]='*modified'})
            # console.log 'updateRecords', record_id, new_record
            za.execute('crm', crmModule, 'updateRecords', record_id, [new_record], (err, _response) ->
              errors = err
              response = _response
              done = true
            )

          waitsFor ->
            return done

          runs ->
            # console.log "can update record by id", errors, response.data
            expect(errors).toBe(null)
            expect(response).toBeDefined()
            expect(response.data).toBeDefined()
            expect(response.data.Id).toBeDefined()

        it "can fetch all records", ->
          runs ->
            za.execute('crm', crmModule, 'getRecords', {}, (err, _response) ->
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
            expect(response.data.length).toBeGreaterThan(1)
        
        it "can fetch my records", ->
          runs ->
            za.execute('crm', crmModule, 'getMyRecords', {}, (err, _response) ->
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
            expect(response.data.length).toBeGreaterThan(1)
          
        describe "attachment of type Link", ->
          file_link = "https://picsum.photos/200/300/?random"

          it "can upload attachment", ->
            runs ->
              za.execute('crm',crmModule,'uploadFile', record_id, file_link, false, (err, _response) ->
                errors = err
                response = _response
                done = true
              )

            waitsFor ->
              return done

            runs ->
              # console.log "can upload attachment", response.data
              file_id = response.data.Id
              expect(errors).toBe(null)
              expect(response).toBeDefined()
              expect(response.data).toBeDefined()
              expect(response.data.Id).toBeDefined()

          it "canot download attachment", ->
            runs ->
              za.execute('crm',crmModule,'downloadFile',file_id, (err, _response) ->
                errors = err
                response = _response
                done = true
              )

            waitsFor ->
              return done

            runs ->
              # console.log "canot download attachment", errors
              expect(errors).toBeDefined()
              expect(errors.code).toBeDefined()
              expect(errors.message).toBeDefined()

          if config.delete
            it "can delete file", ->
              runs ->
                za.execute('crm',crmModule,'deleteFile', file_id, (err, _response) ->
                  errors = err
                  response = _response
                  done = true
                )

              waitsFor ->
                return done

              runs ->
                # console.log "can delete attachment", response.data
                expect(errors).toBe(null)
                expect(response).toBeDefined()
                expect(response.data).toBeDefined()
                expect(response.data.success).toBeDefined()

          if config.image
            describe  "attachment of type File", ->
              descriptor = config.image
              file = fs.readFileSync(descriptor)
              it "can upload file", ->
                runs ->
                  za.execute('crm',crmModule,'uploadFile', record_id, file, descriptor, (err, _response) ->
                    errors = err
                    response = _response
                    done = true
                  )

                waitsFor ->
                  return done

                runs ->
                  # console.log "can upload file", response.data
                  file_id = response.data.Id
                  expect(errors).toBe(null)
                  expect(response).toBeDefined()
                  expect(response.data).toBeDefined()
                  expect(response.data.Id).toBeDefined()

              it "can download file", ->
                runs ->
                  za.execute('crm',crmModule,'downloadFile',file_id, (err, _response) ->
                    errors = err
                    response = _response
                    done = true
                  )

                waitsFor ->
                  return done

                runs ->
                  # console.log "can download file", response.data
                  expect(errors).toBe(null)
                  expect(response).toBeDefined()
                  expect(response.data).toBeDefined()
                  expect(response.data.buffer).toBeDefined()

              if config.delete
                it "can delete file", ->
                  runs ->
                    za.execute('crm',crmModule,'deleteFile', file_id, (err, _response) ->
                      errors = err
                      response = _response
                      done = true
                    )

                  waitsFor ->
                    return done

                  runs ->
                    # console.log "can delete file", response.data
                    expect(errors).toBe(null)
                    expect(response).toBeDefined()
                    expect(response.data).toBeDefined()
                    expect(response.data.success).toBeDefined()
                    
        if config.delete
          it "can delete record by id", ->
            
            runs ->
              # console.log 'deleteRecords', record_id
              za.execute('crm', crmModule, 'deleteRecords', record_id, (err, _response) ->
                errors = err
                response = _response
                done = true
              )

            waitsFor ->
              return done

            runs ->
              # console.log "can delete record by id", errors, response.data
              expect(errors).toBe(null)
              expect(response).toBeDefined()
              expect(response.data).toBeDefined()
              expect(response.data.success).toBeDefined()
              
        it "can delete note by id", ->
        
          runs ->
            # console.log 'deleteRecords', note_id
            za.execute('crm', 'Notes', 'deleteRecords', note_id, (err, _response) ->
              errors = err
              response = _response
              done = true
            )
        
          waitsFor ->
            return done
        
          runs ->
            # console.log "can delete note by id", errors, response.data
            expect(errors).toBe(null)
            expect(response).toBeDefined()
            expect(response.data).toBeDefined()
            expect(response.data.success).toBeDefined()
    )
