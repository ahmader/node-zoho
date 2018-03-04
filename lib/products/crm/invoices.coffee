CrmModule = require('./crm-module')

class Invoices extends CrmModule
  name: 'Invoices'

  getSearchRecordsByPDC: ->
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

module.exports = Invoices
