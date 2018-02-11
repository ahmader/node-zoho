_ = require('underscore')
xml2js = require("xml2js")

CrmModule = require('./crm-module')
Request = require('../../request')

class Events extends CrmModule
  name: 'Events'

  getMyRecords: ->
    throw new Error('Not Implemented')

  getSearchRecordsByPDC: ->
    throw new Error('Not Implemented')

  deleteRecords: ->
    throw new Error('Not Implemented')

  convertLead: (lead_id, options, cb) ->
    if not lead_id
      throw new Error('Requires a Lead Id')
    if not options
      throw new Error('Requires an options')
    defaults = {
      createPotential: false,
      assignTo: null,
      notifyLeadOwner: true,
      notifyNewEntityOwner: true
    }
    _.defaults(options,options)
    records = [ _.pick(options,['createPotential','assignTo','notifyLeadOwner','notifyNewEntityOwner'])]

    if options.createPotential == true and not _.isObject(options.potential)
      throw new Error('Requires a potential')
    else if options.createPotential == true
      records.push(options.potential)


    query = {
      leadId: lead_id
      newFormat: 1,
      xmlData: @build(records)
    }
    options = {
      method: 'POST'
    }

    url = @buildUrl(query,['convertLead'],options)
    request = new Request(@, url)

    request.request( (err,response) =>
      if err
        if _.isFunction(cb) then cb(err,null)
      else
        processed = @processRecord(response.data)
        response.data = processed
        if _.isFunction(cb) then cb(null,response)
    )

  getRelatedRecords: ->
    throw new Error('Not Implemented')

  updateRelatedRecords: ->
    throw new Error('Not Implemented')

  getUsers: ->
    throw new Error('Not Implemented')

  downloadFile: ->
    throw new Error('Not Implemented')

  deleteFile: ->
    throw new Error('Not Implemented')

  downloadPhoto:  ->
    throw new Error('Not Implemented')

  deletePhoto:  ->
    throw new Error('Not Implemented')

module.exports = Events
