_ = require('underscore')

CrmModule = require('./crm-module')
Request = require('../../request')

class Leads extends CrmModule
  name: 'Leads'

  getSearchRecordsByPDC: ->
    throw new Error('Not Implemented')

  convertLead: (lead_id, options, cb) ->
    throw new Error('Not Implemented')

  getRelatedRecords: ->
    throw new Error('Not Implemented')

  updateRelatedRecords: ->
    throw new Error('Not Implemented')

  getUsers: ->
    throw new Error('Not Implemented')

  downloadPhoto:  ->
    throw new Error('Not Implemented')

  deletePhoto:  ->
    throw new Error('Not Implemented')

module.exports = Leads
