(function() {
  var Lead, Record, RecordSet,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Record = (function() {
    var _data;

    function Record() {}

    _data = {};

    Record.prototype.getXmlObj = function(index) {
      var key, val, xmlRecordObj, _ref;
      xmlRecordObj = {
        "$": {
          no: index
        },
        FL: []
      };
      _ref = this._data;
      for (key in _ref) {
        val = _ref[key];
        xmlRecordObj.FL.push({
          "$": {
            val: key
          },
          "_": val
        });
      }
      return xmlRecordObj;
    };

    return Record;

  })();

  Lead = (function(_super) {
    __extends(Lead, _super);

    function Lead(_data) {
      this._data = _data;
    }

    return Lead;

  })(Record);

  RecordSet = (function() {
    function RecordSet(_records) {
      this._records = _records;
    }

    RecordSet.prototype.getXmlObj = function() {
      var i, record, xmlObj, _i, _len, _results;
      xmlObj = {
        row: []
      };
      _results = [];
      for (i = _i = 0, _len = records.length; _i < _len; i = ++_i) {
        record = records[i];
        _results.push(xmlObj.row.push(record.getXmlObj(i)));
      }
      return _results;
    };

    return RecordSet;

  })();

}).call(this);
