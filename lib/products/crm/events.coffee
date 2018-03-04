CrmModule = require('./crm-module')

class Events extends CrmModule
  name: 'Events'

  getSearchRecordsByPDC: ->
    throw new Error('Not Implemented')

  convertLead: ->
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

module.exports = Events
