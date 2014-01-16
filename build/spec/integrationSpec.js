(function() {
  var help, zoho;

  help = require("../lib/helpers");

  zoho = require("../lib/node-zoho");

  describe("node-zoho", function() {
    var done, errors, results;
    results = errors = done = void 0;
    beforeEach(function() {
      return results = errors = done = void 0;
    });
    return it("has a constructor", function() {
      var lead, options;
      options = {
        authToken: ""
      };
      lead = {
        "Lead Source": "Site Registration",
        "First Name": "Hannah",
        "Last Name": "Smith",
        Email: "belfordz66@gmail.com"
      };
      runs(function() {
        var za;
        za = new zoho(options);
        return za.insertRecords("leads", lead, function(err, res) {
          errors = err;
          results = res;
          return done = true;
        });
      });
      waitsFor(function() {
        return done;
      });
      return runs(function() {
        return expect(errors).toBe(null);
      });
    });
  });

}).call(this);
