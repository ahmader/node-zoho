(function() {
  var https;

  https = require("https");

  module.exports = {
    request: function(reqUrl, cb) {
      var req;
      req = https.request(reqUrl, function(res) {
        var chunks;
        chunks = void 0;
        res.on('data', function(chunk) {
          if ((chunk != null ? chunk.status : void 0) === "error") {
            return cb(new Error("Recieved error: " + chunk), null);
          } else {
            return chunks += chunk;
          }
        });
        return res.on("end", function() {
          if (res.statusCode !== 200) {
            return cb(new Error("Bad Status code: " + res.statusCode), null);
          } else {
            return cb(null, chunks);
          }
        });
      });
      req.end();
      return req.on('error', function(e) {
        return cb(e, null);
      });
    }
  };

}).call(this);
