_ = require('underscore')
xml2js = require("xml2js")

BaseModule = require('../../base-module')
Request = require('../../request')

class Leads extends BaseModule
  name: 'Leads'

  buildRecord: (record) ->
    if not _.isObject(record)
      throw new Error('Object required')
    result = []
    for k, v of record
      result.push({
        $:
          val: k
        _: v
      })
    return result

  buildRecords: (records) ->
    if not _.isArray(records)
      throw new Error('Requires array of records')
    rows = []
    for record,index in records
      record_result = @buildRecord(record)
      rows.push({
        $:
          no: index + 1
        FL: record_result
      })
    return rows

  build: (records) ->
    xmlBuilder = new xml2js.Builder(
      rootName: @name
      renderOpts:
        pretty: false
      xmldec:
        version: "1.0"
        encoding: "UTF-8"
    )
    xmlObj = {
      row: @buildRecords(records)
    }

    xmlString = xmlBuilder.buildObject(xmlObj)

    return xmlString

  processRecord: (record) ->
    result = {}
    if _.isArray(record)
      for i,r of record
        _.extend(result, @processRecord(r))
    else if _.isObject(record)
      for k,v of record
        if k is 'FL'
          for i,fl of v
            if fl?.$?.val and fl?._
              result[fl.$.val] = fl._


    return result

  getMyRecords: ->
    throw new Error('Not Implemented')

  getRecords:  ->
    throw new Error('Not Implemented')

  getRecordById: ->
    throw new Error('Not Implemented')

  insertRecords: (records,cb) ->
    if not _.isArray(records)
      throw new Error('Requires array of records')
    if records.length < 1
      throw new Error('Requires as least one record')

    query = {
      newFormat: 1,
      xmlData: @build(records)
    }
    options = {
      method: 'POST'
    }
    url = @buildUrl(query,['insertRecords'],options)
    request = new Request(@,url)

    request.request((err,response) =>
      if err
        if _.isFunction(cb) then cb(err,null)
      else
        processed = @processRecord(response.data)
        response.data = processed
        if _.isFunction(cb) then cb(null,response)
    )

  updateRecords: ->
    throw new Error('Not Implemented')

  getSearchRecords: ->
    throw new Error('Not Implemented')

  getSearchRecordsByPDC: ->
    throw new Error('Not Implemented')

  deleteRecords: ->
    throw new Error('Not Implemented')

  convertLead: ->
    throw new Error('Not Implemented')

  getRelatedRecords: ->
    throw new Error('Not Implemented')

  getFields: ->
    throw new Error('Not Implemented')

  updateRelatedRecords: ->
    throw new Error('Not Implemented')

  getUsers: ->
    throw new Error('Not Implemented')

  uploadFile: ->
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

module.exports = Leads
