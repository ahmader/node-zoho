(function() {
  var help, zoho;

  help = require("../lib/helpers");

  zoho = require("../lib/node-zoho");

  describe("node-zoho", function() {
    var done, errors, results;
    console.log("da fuck");
    results = errors = done = void 0;
    beforeEach(function() {
      return results = errors = done = void 0;
    });
    return it("has a constructor", function() {
      var lead, options, za;
      options = {
        authToken: "5d87c47daf8c9d836b65fa6269e06e6d"
      };
      lead = {
        "Lead Source": "Site Registration",
        "First Name": "Hannah",
        "Last Name": "Smith",
        Email: "belfordz66@gmail.com"
      };
      za = void 0;
      runs(function() {
        return za = new zoho(options);
      });
      waitsFor(function() {
        return done;
      });
      runs(function() {
        expect(errors).toBe(null);
        done = errors = void 0;
        return za.insertLeads("leads", lead, function(err, res) {
          console.log(res);
          errors = err;
          results = res;
          return done = true;
        });
      });
      waitsFor(function() {
        return done;
      });
      return runs(function() {
        expect(errors).toBe(null);
        return console.log(res);
      });
    });
  });

}).call(this);
