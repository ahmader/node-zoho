CrmModule = require('./crm-module')

class CustomModule1 extends CrmModule
  name: 'CustomModule1'

  getMyRecords: ->
    throw new Error('Not Implemented')

  getSearchRecordsByPDC: ->
    throw new Error('Not Implemented')

  deleteRecords: ->
    throw new Error('Not Implemented')

  convertLead: ->
    throw new Error('Not Implemented')

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

  uploadPhoto: ->
    throw new Error('Not Implemented')
    
  downloadPhoto:  ->
    throw new Error('Not Implemented')

  deletePhoto:  ->
    throw new Error('Not Implemented')

module.exports = CustomModule1
