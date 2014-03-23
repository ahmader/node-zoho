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
      options = _.extend({type:'FL'},record._options)
      row = {
        $:
          no: index + 1
      }
      row[options.type] = record_result
      rows.push(row)
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
      if _.has(record,'FL')
        for k,v of record
          if k is 'FL'
            for i,fl of v
              if fl?.$?.val and fl?._
                result[fl.$.val] = fl._
      else if _.has(record,'success')
        record = record.success
        for k,v of record
          if k is 'Contact' or k is 'Potential'
            result[k] = {}
            _.each(v, (_v) =>
              _.extend(result[k],@processRecord(_v))
            )
      else if _.has(record,'_') and _.has(record,'$') and _.has(record.$,'param')
        result[record.$.param] = record._
      else if _.has(record,'_') and _.has(record,'$') and _.has(record.$,'val')
        result[record.$.val] = record._

    return result

  getMyRecords: ->
    throw new Error('Not Implemented')

  getRecords: (id, cb) ->
    query = {
      newFormat: 1
    }

    options = {
      method: 'GET'
    }

    url = @buildUrl(query,['getRecords'],options)

    request = new Request(@, url)

    request.request( (err,response) =>
      if err
        if _.isFunction(cb) then cb(err,null)
      else
        _data = response.data
        response.data = Array()

        if _data?.Leads
          for row of _data.Leads[0].row
            processed = @processRecord(_data.Leads[0].row[row])
            if processed
              response.data = processed


        if _.isFunction(cb) then cb(null,response)
    )


  getRecordById: (id, cb) ->
    if not id
      throw new Error('Requires an Id to fetch')

    query = {
      id: id
      newFormat: 1
    }

    options = {
      method: 'GET'
    }

    url = @buildUrl(query,['getRecordById'],options)

    request = new Request(@, url)

    request.request( (err,response) =>
      if err
        if _.isFunction(cb) then cb(err,null)
      else
        if response.data?.Leads
          row = _.first(response.data?.Leads)
          processed = @processRecord(_.first(row.row))
          response.data = processed

        if _.isFunction(cb) then cb(null,response)
    )

  insertRecords: (records, cb) ->
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
    request = new Request(@, url)

    request.request( (err,response) =>
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
