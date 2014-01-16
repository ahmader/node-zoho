(function() {
  var help, xml2js, zoho, zohoApi;

  xml2js = require("xml2js");

  help = require("../lib/helpers");

  zoho = require("../lib/node-zoho");

  zohoApi = void 0;

  describe("node-zoho", function() {
    var done, errors, lead, options, results;
    results = errors = done = void 0;
    options = {
      authToken: ""
    };
    lead = {
      "Lead Source": "Site Registration",
      "First Name": "Hannah",
      "Last Name": "Smith",
      Email: "belfordz66@gmail.com"
    };
    beforeEach(function() {
      zohoApi = new zoho();
      done = false;
      return results = errors = void 0;
    });
    describe("constructor", function() {
      return it("exists", function() {
        return expect(typeof zoho).toBe("function");
      });
    });
    return describe("instance", function() {
      describe("has a public method", function() {
        describe("generateAuthToken", function() {
          beforeEach(function() {
            return spyOn(help, "request").andCallFake(function() {
              var cb;
              cb = arguments[arguments.length - 1];
              if (typeof cb !== "function") {
                throw new Error("mockModelCb: the cb called is not a function.");
              }
              return setImmediate(cb, null, "AUTHTOKEN:123\n");
            });
          });
          return it("makes a call to help.request with proper data", function() {
            runs(function() {
              return zohoApi.generateAuthToken("cool@picatic.com", "seriously, cool", function(err, res) {
                results = res;
                errors = err;
                return done = true;
              });
            });
            waitsFor(function() {
              return done;
            });
            return runs(function() {
              return expect(help.request).toHaveBeenCalledWith({
                host: 'accounts.zoho.com',
                port: 443,
                path: '/apiauthtoken/nb/create?SCOPE=ZohoCRM/crmapi&EMAIL_ID=cool@picatic.com&PASSWORD=seriously, cool',
                method: 'POST'
              }, jasmine.any(Function));
            });
          });
        });
        return describe("insertRecord", function() {
          var mockBuilder, xmlBuilder;
          xmlBuilder = mockBuilder = void 0;
          beforeEach(function() {
            spyOn(zohoApi, "_buildRecordsXmlObj").andReturn({});
            mockBuilder = {
              buildObject: function() {
                return "wicked";
              }
            };
            spyOn(xml2js, "Builder").andReturn(mockBuilder);
            xmlBuilder = new xml2js.Builder();
            spyOn(xmlBuilder, "buildObject").andReturn("");
            spyOn(zohoApi, "_buildQueryUrl").andReturn("b");
            spyOn(help, "request").andCallFake(function() {
              var cb;
              cb = arguments[arguments.length - 1];
              if (typeof cb !== "function") {
                throw new Error("mockModelCb: the cb called is not a function.");
              }
              return setImmediate(cb, null, "All Good");
            });
            return spyOn(xml2js, "parseString").andCallFake(function() {
              var cb;
              cb = arguments[arguments.length - 1];
              if (typeof cb !== "function") {
                throw new Error("mockModelCb: the cb called is not a function.");
              }
              return setImmediate(cb, null, "All Good");
            });
          });
          it("builds an object to convert to xml", function() {
            runs(function() {
              return zohoApi.insertRecords("a", "b", function(err, res) {
                results = res;
                errors = err;
                return done = true;
              });
            });
            waitsFor(function() {
              return done;
            });
            return runs(function() {
              return expect(zohoApi._buildRecordsXmlObj).toHaveBeenCalled();
            });
          });
          it("builds the xmlString", function() {
            runs(function() {
              return zohoApi.insertRecords("a", "b", function(err, res) {
                results = res;
                errors = err;
                return done = true;
              });
            });
            waitsFor(function() {
              return done;
            });
            return runs(function() {
              expect(xml2js.Builder).toHaveBeenCalled();
              return expect(mockBuilder.buildObject).toHaveBeenCalled();
            });
          });
          it("builds the url for the request", function() {
            runs(function() {
              return zohoApi.insertRecords("a", "b", function(err, res) {
                results = res;
                errors = err;
                return done = true;
              });
            });
            waitsFor(function() {
              return done;
            });
            return runs(function() {
              return expect(zohoApi._buildQueryUrl).toHaveBeenCalled();
            });
          });
          return it("sends the request", function() {
            runs(function() {
              return zohoApi.insertRecords("a", "b", function(err, res) {
                results = res;
                errors = err;
                return done = true;
              });
            });
            waitsFor(function() {
              return done;
            });
            return runs(function() {
              return expect(help.request).toHaveBeenCalled();
            });
          });
        });
      });
      return xdescribe("has a private method", function() {
        describe("_buildQueryUrl", function() {});
        return describe("_buildRecordsXmlObj", function() {});
      });
    });
  });

}).call(this);
