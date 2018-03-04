CrmModule = require('./crm-module')

class Notes extends CrmModule
  name: 'Notes'

  getMyRecords: ->
    throw new Error('Not Implemented')

  updateRecords: ->
    throw new Error('Not Implemented')

  getSearchRecords: ->
    throw new Error('Not Implemented')

  getSearchRecordsByPDC: ->
    throw new Error('Not Implemented')

  getRelatedRecords: ->
    throw new Error('Not Implemented')

  getFields: ->
    throw new Error('Not Implemented')

  updateRelatedRecords: ->
    throw new Error('Not Implemented')

  getUsers: ->
    throw new Error('Not Implemented')

  downloadPhoto:  ->
    throw new Error('Not Implemented')

  deletePhoto:  ->
    throw new Error('Not Implemented')

module.exports = Notes
