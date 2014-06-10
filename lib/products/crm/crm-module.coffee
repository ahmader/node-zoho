_ = require('underscore')
xml2js = require("xml2js")

BaseModule = require('../../base-module')
Request = require('../../request')

class CrmModule extends BaseModule

  buildRecord: (record) ->
    if not _.isObject(record)
      throw new Error('Object required')
    result = []
    for k, v of record
      if Array.isArray v
        # FIXME: tbd how to pass nested tag name, currently hardcoded to "project"
        result.push({
          $:
            val: k
          product: @buildRecords v
        })
      else
        result.push({
          $:
            val: k
          _: v
        })
    return result

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

  getRecords: (_query, cb) ->
    query = _.extend({
      newFormat: 1
    }, _query)

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

        if _data?[@name]
          for row of _data[@name][0].row
            processed = @processRecord(_data[@name][0].row[row])
            if processed
              response.data.push(processed)


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
        if response.data?.Events
          row = _.first(response.data?.Events)
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

  deleteRecords: (id, cb) ->
    if not id
      throw new Error('Requires an Id to delete')

    query = {
      id: id
      newFormat: 1
    }

    options = {
      method: 'POST'
    }

    url = @buildUrl(query,['deleteRecords'],options)

    request = new Request(@, url)

    request.request( (err,response) =>
      if err
        if _.isFunction(cb) then cb(err,null)
      else
        if response.data?.Events
          row = _.first(response.data?.Events)
          processed = @processRecord(_.first(row.row))
          response.data = processed

        if _.isFunction(cb) then cb(null,response)
    )

  getSearchRecordsByPDC: (_query, cb) ->
    query = _.extend({
      newFormat: 1,
      selectColumns: 'All'
    }, _query)

    options = {
      method: 'GET'
    }

    url = @buildUrl(query,['getSearchRecordsByPDC'],options)

    request = new Request(@, url)

    request.request( (err,response) =>
      if err
        if _.isFunction(cb) then cb(err,null)
      else
        _data = response.data
        response.data = Array()

        if _data?[@name]
          for row of _data[@name][0].row
            processed = @processRecord(_data[@name][0].row[row])
            if processed
              response.data.push(processed)

        if _.isFunction(cb) then cb(null,response)
    )

module.exports = CrmModule
