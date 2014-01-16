(function() {
  var Zoho, async, helpers, https, url, xml2js, _;

  url = require("url");

  https = require("https");

  _ = require("underscore");

  async = require("async");

  xml2js = require("xml2js");

  helpers = require("./helpers");

  Zoho = (function() {
    function Zoho(options) {
      if (options == null) {
        options = {};
      }
      this.authDefaults = {
        host: "accounts.zoho.com",
        port: 443,
        path: "/apiauthtoken/nb/create?SCOPE=ZohoCRM/crmapi"
      };
      this.crmApiDefaults = {
        host: "crm.zoho.com",
        port: 443,
        path: {
          api: "crm",
          access: "private",
          encoding: "xml",
          resource: "Leads",
          method: "insertRecords"
        },
        query: {
          scope: "crmapi",
          authToken: void 0
        }
      };
      this.xmlBuilderOpts = {
        renderOpts: {
          pretty: false
        },
        xmldec: {
          version: "1.0",
          encoding: "UTF-8"
        }
      };
      if (options != null ? options.authToken : void 0) {
        this.crmApiDefaults.query.authToken = options != null ? options.authToken : void 0;
      }
      return this;
    }

    Zoho.prototype.generateAuthToken = function(email, password, cb) {
      var authUrl, flow,
        _this = this;
      if (email === void 0 || typeof email !== "string") {
        return cb(new Error("An email string must be provided"));
      } else if (password === void 0 || typeof email !== "string") {
        return cb(new Error("A password string must be provided"));
      } else if (typeof cb !== "function") {
        throw new Error("the last argument to generateAuthToken must be a function");
      }
      flow = [];
      authUrl = _.clone(this.authDefaults);
      authUrl.path = "" + authUrl.path + "&EMAIL_ID=" + email + "&PASSWORD=" + password;
      authUrl.method = "POST";
      flow.push(function(_cb) {
        return helpers.request(authUrl, _cb);
      });
      flow.push(function(response, _cb) {
        var endInd, ind;
        ind = response.indexOf("AUTHTOKEN");
        if (ind === -1) {
          return _cb(new Error("Auth token generation failed"), null);
        } else {
          endInd = response.indexOf("\n", ind);
          return _cb(null, response.substring(ind + 10, endInd));
        }
      });
      return async.waterfall(flow, function(err, results) {
        if (err) {
          return cb(err, null);
        } else {
          _this.authToken = _this.crmApiDefaults.query.authToken = results;
          return cb(null, results);
        }
      });
    };

    Zoho.prototype.insertRecords = function(resource, records, cb) {
      var insertUrl, xmlBuilder, xmlObj, xmlString;
      xmlObj = this._buildRecordsXmlObj(records);
      this.xmlBuilderOpts.rootName = resource;
      xmlBuilder = new xml2js.Builder(this.xmlBuilderOpts);
      xmlString = xmlBuilder.buildObject(xmlObj);
      insertUrl = this._buildQueryUrl({
        path: {
          resource: resource,
          method: "insertRecords"
        },
        query: {
          newFormat: 1,
          xmlData: xmlString
        },
        method: "POST"
      });
      return helpers.request(insertUrl, function(err, zohoRes) {
        return xml2js.parseString(zohoRes, function(err, xml) {
          if (err) {
            return cb(err, null);
          } else {
            return cb(null, xml);
          }
        });
      });
    };

    Zoho.prototype.getRecords = function(resource, params, cb) {
      /*
      insertUrl = @_buildQueryUrl({
        path:
          resource: resource
          method: "insertRecords"
        query:
          selectColumns: "all"
          searchCondition:
          version: 2
      })
      */

    };

    Zoho.prototype._buildQueryUrl = function(urlObj) {
      var path, query;
      path = _.defaults(this.crmApiDefaults.path, urlObj.path);
      query = _.defaults(this.crmApiDefaults.query, urlObj.query);
      query = "?authtoken=" + query.authToken + "&scope=" + query.scope + "&xmlData=" + (encodeURI(query.xmlData)) + "&newFormat=1";
      urlObj = _.defaults(this.crmApiDefaults, urlObj);
      path = "/" + path.api + "/" + path.access + "/" + path.encoding + "/" + path.resource + "/" + path.method + query;
      delete urlObj.query;
      urlObj.path = path;
      return urlObj;
    };

    Zoho.prototype._buildRecordsXmlObj = function(records) {
      var i, key, record, val, xmlObj, xmlRowObj, _i, _len;
      if (!_.isArray(records)) {
        records = [records];
      }
      xmlObj = {
        row: []
      };
      for (i = _i = 0, _len = records.length; _i < _len; i = ++_i) {
        record = records[i];
        xmlRowObj = {
          "$": {
            no: i
          },
          FL: []
        };
        for (key in record) {
          val = record[key];
          xmlRowObj.FL.push({
            "$": {
              val: key
            },
            "_": val
          });
        }
        xmlObj.row.push(xmlRowObj);
      }
      return xmlObj;
    };

    return Zoho;

  })();

  module.exports = Zoho;

}).call(this);
