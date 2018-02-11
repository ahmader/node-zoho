_ = require('underscore')
xml2js = require("xml2js")

CrmModule = require('./crm-module')
Request = require('../../request')

class Invoices extends CrmModule
  name: 'Invoices'

  getMyRecords: ->
    throw new Error('Not Implemented')

  getRecords: (_query, cb) ->
    throw new Error('Not Implemented')

  getRecordById: (id, cb) ->
    throw new Error('Not Implemented')

  updateRecords: ->
    throw new Error('Not Implemented')

  getSearchRecords: ->
    throw new Error('Not Implemented')

  getSearchRecordsByPDC: ->
    throw new Error('Not Implemented')

  deleteRecords: ->
    throw new Error('Not Implemented')

  getRelatedRecords: ->
    throw new Error('Not Implemented')

  getFields: ->
    throw new Error('Not Implemented')

  updateRelatedRecords: ->
    throw new Error('Not Implemented')

  getUsers: ->
    throw new Error('Not Implemented')

  downloadFile: ->
    throw new Error('Not Implemented')

  deleteFile: ->
    throw new Error('Not Implemented')

  uploadPhoto: ->
    throw new Error('Not Implemented')

  downloadPhoto:  ->
    throw new Error('Not Implemented')

  deletePhoto:  ->
    throw new Error('Not Implemented')

module.exports = Invoices
